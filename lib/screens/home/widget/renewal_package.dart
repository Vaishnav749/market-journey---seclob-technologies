import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:master_journey/screens/home/widget/subscription.dart';
import 'package:master_journey/services/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../resources/color.dart';
import '../../../support/logger.dart';

class Renewalpackage extends StatefulWidget {
  const Renewalpackage({super.key});

  @override
  State<Renewalpackage> createState() => _RenewalpackageState();
}

class _RenewalpackageState extends State<Renewalpackage> {
  var userid;
  List<dynamic> renewalPackage = [];
  List<dynamic> renewalcoPackage = [];
  XFile? _imageFile;

  Future<void> _viewpak() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await homeservice.viewRenewalpackage();
      log.i('Profile data show.... $response');
      setState(() {
        renewalPackage = response['renewPackages'] ?? [];
      });
    } catch (error) {
      log.e('Error fetching subscription history data: $error');
    }
  }

  Future<void> _viewrenewpak() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await homeservice.viewConvertpackage();
      log.i('Profile data show.... $response');
      setState(() {
        renewalcoPackage = response['anotherPackages'] ?? [];
      });
    } catch (error) {
      log.e('Error fetching subscription history data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _viewpak();
    _viewrenewpak();
  }

  Future<void> _pickImage(StateSetter setState) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imageFile = pickedFile;
    });
  }

  void _showPackageDetails(BuildContext context, dynamic transaction) {
    TextEditingController _transactionIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(

              child: AlertDialog(

                title: Text('Renewal Package', style: TextStyle(color: yellow1)),
                content: Column(

                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      transaction['packageName'] ?? 'No Name',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text("₹${transaction['packageAmount'] ?? '0'}"),
                    SizedBox(height: 20),
                    _imageFile == null
                        ? Text("No image selected.")
                        : Text(
                      (_imageFile?.path ?? 'No image selected').substring(
                        (_imageFile?.path ?? 'No image selected').length -
                            50,
                      ),
                    ),
                    SizedBox(height: 20),
                    TextField(
                      controller: _transactionIdController,
                      decoration: InputDecoration(
                        labelText: 'Transaction ID',
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _pickImage(setState),
                      child: Text("Upload Screenshot"),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Close"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      double? packageAmount =
                      double.tryParse(transaction['packageAmount'].toString());
                      if (packageAmount == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Invalid package amount.'),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return;
                      }
                      uploadPackageDetails(
                        packageName: transaction['packageName'],
                        packageAmount: packageAmount,
                        image: _imageFile,
                        transactionIdController: _transactionIdController,
                        context: context,
                      );
                    },
                    child: Text("Submit"),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> uploadPackageDetails({
    required String packageName,
    required double packageAmount,
    required XFile? image,
    required TextEditingController transactionIdController,
    required BuildContext context,
  }) async {
    bool uploading = false;
    bool isLoading = false;

    if (uploading) return;

    setState(() {
      uploading = true;
      isLoading = true;
    });

    try {
      if (image != null) {
        Uint8List uint8List = await image.readAsBytes();

        FormData formData = FormData.fromMap({
          'reqPackage': packageName,
          'amount': packageAmount,
          'action':"addOn",
          'screenshot': MultipartFile.fromBytes(
            uint8List,
            filename: 'image.png',
          ),
          'transactionNumber': transactionIdController.text,
        });

        // Retrieve token from SharedPreferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        String? token = prefs.getString('token');

        print("Starting upload...");

        int retryCount = 0;
        const maxRetries = 3;
        Response? response;

        while (retryCount < maxRetries) {
          try {
            response = await Dio().post(
              'https://admin.marketjourney.in/api/user/user-renewal-request',
              data: formData,
              options: Options(
                headers: {
                  'Authorization': 'Bearer $token',
                },
                validateStatus: (status) {
                  return status! < 500; // Allow statuses less than 500 to pass
                },
              ),
            );
            break; // Break the loop if the request is successful
          } on DioError catch (e) {
            retryCount++;
            if (retryCount >= maxRetries || e.response?.statusCode != 502) {
              throw e; // Re-throw the error if max retries are reached or if it's not a 502
            }
            await Future.delayed(Duration(seconds: 2)); // Delay before retrying
          }
        }

        if (response != null) {
          print("Upload response: ${response.statusCode}");
          handleResponse(response);
          if (response.statusCode == 200) {
            // Navigate to the login page upon successful upload
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Subscription()));
          }
        } else {
          print("No image to upload.");
        }
      }
    } on DioError catch (e) {
      print("Exception during media upload: $e");
      String errorMessage = "Connection error. Please try again.";
      if (e.type == DioErrorType.connectionError) {
        errorMessage = "No Internet connection. Please check your network.";
      } else if (e.response?.statusCode == 502) {
        errorMessage = "Server error. Please try again later.";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print("Exception during media upload: $e");
    } finally {
      setState(() {
        uploading = false;
        isLoading = false;
      });
    }
  }

  void handleResponse(Response response) {
    // Handle the response from the server
    // You can parse the response and show messages to the user if needed
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenOrientation = MediaQuery.of(context).orientation;
    bool isPortrait = screenOrientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Renewal Package ',
          style: TextStyle(color: black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: marketbg,
      ),
      backgroundColor: marketbg,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(left: 20),
            ),
            SizedBox(height: 10),
            Text(
              "Add on",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: yellow1,
                  fontSize: 15),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: renewalPackage.length,
              itemBuilder: (BuildContext context, int index) {
                var transaction = renewalPackage[index];
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () => _showPackageDetails(context, transaction),
                    child: Container(
                      height: 80,
                      width: 300,
                      decoration: BoxDecoration(
                        color: bluem,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction['packageName'] ?? 'No Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: marketbg,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "₹${transaction['packageAmount'] ?? '0'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: marketbg,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
            Text(
              "Convert Packages",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: yellow1,
                  fontSize: 15),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: renewalcoPackage.length,
              itemBuilder: (BuildContext context, int index) {
                var transaction2 = renewalcoPackage[index];
                return Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: GestureDetector(
                    onTap: () => _showPackageDetails(context, transaction2),
                    child: Container(
                      height: 80,
                      width: 300,
                      decoration: BoxDecoration(
                        color: bluem,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  transaction2['packageName'] ?? 'No Name',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: marketbg,
                                  ),
                                ),
                              ],
                            ),
                            Expanded(child: SizedBox()),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "₹${transaction2['packageAmount'] ?? '0'}",
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: marketbg,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
