import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:master_journey/authentication_page/login.dart';
import 'package:master_journey/resources/color.dart';

import '../navigation/bottom_tabs_screen.dart';
import '../services/profile_service.dart';
import '../support/logger.dart'; // Import the next page widget

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  File? _image;
  bool uploading = false;
  bool isLoading = false;
  String? _fileName;
  var profiledata;
  TextEditingController _transactionIdController =
      TextEditingController(); // Add a controller for the text field

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
        _fileName = pickedFile.name; // Save the file name
      });
      print("Image selected: ${_image!.path}"); // Debug log
    } else {
      print("No image selected."); // Debug log
    }
  }
  Future _initLoad() async {
    await Future.wait(
      [
        _ProfileData(),
        ///////
      ],
    );
    isLoading = false;
  }
  Future _ProfileData() async {
    var response = await ProfileService.profile();
    log.i('Profile data show.... $response');
    setState(() {
      profiledata = response;
      isLoading = false;
    });
  }
  Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  Future<void> uploadMedia() async {
    if (uploading) return;

    setState(() {
      uploading = true;
      isLoading = true;
    });

    try {
      if (_image != null) {
        Uint8List uint8List = await _image!.readAsBytes();

        FormData formData = FormData.fromMap({
          'screenshot': MultipartFile.fromBytes(
            uint8List,
            filename: 'image.png',
          ),
          'description': 'Payment Screenshot',
          'transactionNumber': _transactionIdController.text, // Include transaction ID
        });

        // Retrieve token from SharedPreferences
        String token = await getToken();

        print("Starting upload..."); // Debug log

        int retryCount = 0;
        const maxRetries = 3;
        Response? response;

        while (retryCount < maxRetries) {
          try {
            response = await Dio().post(
              'https://admin.marketjourney.in/api/user/user-verification',
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
          print("Upload response: ${response.statusCode}"); // Debug log
          handleResponse(response);
          if (response.statusCode == 200) {
            // Navigate to the login page upon successful upload
            Navigator.of(context).pushReplacementNamed('/login');
          }
        } else {
          print("No image to upload."); // Debug log
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
    if (response.statusCode == 201) {
      var responseData = response.data;
      var msg = responseData['msg'] ?? 'Upload successful!';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Uploaded ScreenShot successfully Please login Again'),
          backgroundColor: Colors.green,
        ),
      );

      // Navigate to the login page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => loginpage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Upload failed!'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }


  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // Remove the token from SharedPreferences
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => loginpage()),
    );
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initLoad();
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          // Wrap with SingleChildScrollView
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            height: 500,
            width: 312,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(17),
              color: whitegray,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Package Amount',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                  ),
                ),
                SizedBox(
                  height: 9,
                ),
                Text(
                  profiledata['tempPackageAmount'].toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 24,
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Transaction ID",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                SizedBox(
                  height: 32,
                  width: 249,
                  child: TextFormField(
                    controller:
                        _transactionIdController, // Attach the controller
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: yellow, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(4),
                        borderSide: BorderSide(color: yellow, width: 1),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 17,
                ),
                Text(
                  "Payment Screenshot",
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 10,
                  ),
                ),
                SizedBox(
                  height: 4,
                ),
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 249,
                    padding:
                        EdgeInsets.symmetric(vertical: 10), // Add some padding
                    decoration: BoxDecoration(
                      border: Border.all(color: yellow, width: 1),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Center(
                      child: _fileName == null
                          ? Text('Upload Screenshot')
                          : Text(_fileName!, overflow: TextOverflow.ellipsis),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),
                GestureDetector(
                  onTap: uploadMedia,
                  child: Center(
                    child: Container(
                      height: 24,
                      width: 104,
                      padding:
                          EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: yellow1,
                      ),
                      child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 24,
                ),


              ],
            ),
          ),
        ),
      ),
    );
  }
}
