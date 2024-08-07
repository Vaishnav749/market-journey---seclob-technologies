import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../resources/color.dart';
import '../../../services/bank_service.dart';
import '../../../services/member_service.dart';
import '../../../support/logger.dart';

class Demataccount extends StatefulWidget {
  const Demataccount({super.key});

  @override
  State<Demataccount> createState() => _DemataccountState();
}

class _DemataccountState extends State<Demataccount> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController userdemateController = TextEditingController();

  var userId;
  var states;
  var districts;
  var zonals;
  var panchayaths;

  bool _isLoading = false;

  String? statedropdownvalue;
  List<String> stateVal = [];

  String? districtdropdownvalue;
  List<String> districtVal = [];

  String? zonalDropdownvalue;
  List<String> zonalVal = [];

  String? panchayathDropdown;
  List<String> panchayathVal = [];

  Future<bool> _isFieldUnique(String fieldName, String fieldValue) async {
    try {
      bool isUnique = await BankService.checkFieldUnique(fieldName, fieldValue);
      if (!isUnique) {
        log.e('Error checking $fieldName uniqueness: Value already exists');
      }
      return isUnique;
    } catch (error) {
      log.e('Exception while checking $fieldName uniqueness: $error');
      return false;
    }
  }

  Future<void> _addDemate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userid');
    setState(() {
      _isLoading = true;
    });

    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        emailController.text.isEmpty ||
        userdemateController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Validate email format
    String emailPattern = r'^[a-zA-Z0-9._%-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$';
    RegExp regExp = RegExp(emailPattern);
    if (!regExp.hasMatch(emailController.text)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Invalid email format')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    // Check for email, and username uniqueness
    bool isEmailUnique = await _isFieldUnique('email', emailController.text);
    bool isUsernameUnique =
    await _isFieldUnique('demateUserName', userdemateController.text);

    if (!isEmailUnique) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email is already in use')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (!isUsernameUnique) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Username for Demat Account is already in use')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var reqData = {
      'name': nameController.text,
      'phone': int.tryParse(phoneController.text) ?? 0,
      'address': addressController.text,
      'email': emailController.text,
      'demateUserName': userdemateController.text,
      'state': statedropdownvalue,
      'district': districtdropdownvalue,
      'zonal': zonalDropdownvalue,
      'panchayath': panchayathDropdown
    };
    log.i('Request Data: $reqData');
    try {
      var response = await BankService.Demate(reqData);
      if (response['sts'] == '01') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Demat data added successfully')),
        );

        // Clear the fields
        nameController.clear();
        phoneController.clear();
        addressController.clear();
        emailController.clear();
        userdemateController.clear();
        setState(() {
          statedropdownvalue = null;
          districtdropdownvalue = null;
          zonalDropdownvalue = null;
          panchayathDropdown = null;
        });
      } else {
        log.e('Add Demat failed: ${response['msg']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add Demat failed: ${response['msg']}')),
        );
      }
    } catch (error) {
      log.e('Error adding Demat: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding Demat: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future _Dematestate() async {
    try {
      var response = await MemberService.Memberstate();
      log.i('State API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'States retrieved successfully') {
        setState(() {
          states = response;
          stateVal = List<String>.from(
              states['states'].map((state) => state['stateName']));
          log.i('State names extracted: $stateVal');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching states: $e');
    }
  }

  Future<void> _Dematedistrict(String stateId) async {
    try {
      var response = await MemberService.Memberdistrict(stateId);
      log.i('District API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'Districts retrieved success') {
        // Updated condition
        setState(() {
          districts = response['districts'];

          // Extract district names and remove duplicates
          districtVal = List<String>.from(
              districts.map((district) => district['name']).toSet().toList());
          log.i('District names extracted: $districtVal');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching districts: $e');
    }
  }

  Future<void> _Dematezonal(String districtId) async {
    try {
      var response = await MemberService.Memberzonal(districtId);
      log.i('Zonal API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'Zonals retrieved successfully') {
        setState(() {
          zonals = response['zonals'];

          // Extract zonal names and remove duplicates
          zonalVal = List<String>.from(
              zonals.map((zonal) => zonal['name']).toSet().toList());
          log.i('Zonal names extracted: $zonalVal');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching zonals: $e');
    }
  }

  Future<void> _Dematepanchayath(String zonalId) async {
    try {
      var response = await MemberService.Memberpanchayath(zonalId);
      log.i('Panchayath API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'panchayaths retrieved successfully') {
        setState(() {
          panchayaths = response['panchayaths'];

          // Extract panchayath names and remove duplicates
          panchayathVal = List<String>.from(panchayaths
              .map((panchayath) => panchayath['name'])
              .toSet()
              .toList());
          log.i('Panchayath names extracted: $panchayathVal');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching panchayaths: $e');
    }
  }

  Future<void> _initLoad() async {
    await _Dematestate();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text('Demat Account', style: TextStyle(color: black, fontSize: 16)),
        centerTitle: true,
        backgroundColor: marketbg,
      ),
      backgroundColor: marketbg,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          strokeWidth: 6.0,
          valueColor: AlwaysStoppedAnimation(yellow),
        ),
      )
          : SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Name',
                      style:
                      TextStyle(color: marketbgblue, fontSize: 14))),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: nameController,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Mobile Number',
                      style:
                      TextStyle(color: marketbgblue, fontSize: 14))),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly // Allow only numbers
                ],
                controller: phoneController,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Email',
                      style:
                      TextStyle(color: marketbgblue, fontSize: 14))),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Address',
                      style:
                      TextStyle(color: marketbgblue, fontSize: 14))),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'State',
                  style: TextStyle(color: bluem),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow),
                      ),
                      hintText: 'Select State',
                      hintStyle: TextStyle(fontSize: 12, color: bluem),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 10,
                    style: TextStyle(fontSize: 15),
                    items: stateVal.map((String state) {
                      return DropdownMenuItem<String>(
                        value: state,
                        child: Text(
                          state,
                          style: TextStyle(fontSize: 12, color: bluem),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        statedropdownvalue = newVal;
                        districtdropdownvalue = null;
                        districtVal = [];

                        if (statedropdownvalue != null) {
                          try {
                            print('Selected State: $statedropdownvalue');

                            String selectedStateId = states['states']
                                .firstWhere((state) =>
                            state['stateName'] ==
                                statedropdownvalue)['id'];

                            _Dematedistrict(selectedStateId);
                          } catch (e) {
                            print('Error finding State ID: $e');
                          }
                        }
                      });
                    },
                    value: statedropdownvalue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'District',
                  style: TextStyle(color: bluem),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow, width: 1),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow),
                      ),
                      hintText: 'Select District',
                      hintStyle: TextStyle(fontSize: 12, color: bluem),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 10,
                    style: TextStyle(fontSize: 15),
                    items: districtVal.map((String district) {
                      return DropdownMenuItem<String>(
                        value: district,
                        child: Text(
                          district,
                          style: TextStyle(fontSize: 12, color: bluem),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        districtdropdownvalue = newVal;
                        zonalDropdownvalue = null;
                        zonalVal = [];

                        if (districtdropdownvalue != null) {
                          try {
                            print(
                                'Selected District: $districtdropdownvalue');

                            // Assuming districts is a List of Maps
                            String selectedDistrictId = districts
                                .firstWhere((district) =>
                            district['name'] ==
                                districtdropdownvalue)['id']
                                .toString();

                            // Fetch zonal data based on selected district ID
                            _Dematezonal(selectedDistrictId);
                          } catch (e) {
                            print('Error finding District ID: $e');
                          }
                        }
                      });
                    },
                    value: districtdropdownvalue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Zonal',
                  style: TextStyle(color: marketbgblue),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow, width: 2),
                      ),
                      hintText: 'Select Zonal',
                      hintStyle:
                      TextStyle(fontSize: 12, color: marketbgblue),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 10,
                    style: TextStyle(fontSize: 15),
                    items: zonalVal.map((String zonal) {
                      return DropdownMenuItem<String>(
                        value: zonal,
                        child: Text(
                          zonal,
                          style: TextStyle(fontSize: 12, color: bluem),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        zonalDropdownvalue = newVal;
                        panchayathDropdown = null;
                        panchayathVal = [];

                        if (zonalDropdownvalue != null) {
                          try {
                            print('Selected zonals: $zonalDropdownvalue');

                            // Assuming zonals is a List of Maps
                            String selectedZonalId = zonals
                                .firstWhere((zonal) =>
                            zonal['name'] ==
                                zonalDropdownvalue)['id']
                                .toString();

                            // Fetch panchayath data based on selected zonal ID
                            _Dematepanchayath(selectedZonalId);
                          } catch (e) {
                            print('Error finding zonal ID: $e');
                          }
                        }
                      });
                    },
                    value: zonalDropdownvalue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text(
                  'Panchayath',
                  style: TextStyle(color: marketbgblue),
                ),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 45,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                ),
                child: Center(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow, width: 2),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius:
                        BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: yellow, width: 2),
                      ),
                      hintText: 'Select Panchayath',
                      hintStyle:
                      TextStyle(fontSize: 12, color: marketbgblue),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 10,
                    style: TextStyle(fontSize: 15),
                    items: panchayathVal.map((String panchayath) {
                      return DropdownMenuItem<String>(
                        value: panchayath,
                        child: Text(
                          panchayath,
                          style: TextStyle(fontSize: 12, color: bluem),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        panchayathDropdown = newVal;
                      });
                    },
                    value: panchayathDropdown,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('User Name Demat Account',
                      style:
                      TextStyle(color: marketbgblue, fontSize: 14))),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: userdemateController,
                decoration: InputDecoration(
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 2),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            _isLoading
                ? CircularProgressIndicator(
              strokeWidth: 6.0,
              valueColor: AlwaysStoppedAnimation(yellow),
            )
                : ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: yellow,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
              ),
              onPressed: _addDemate,
              child: Text(
                'Submit',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}