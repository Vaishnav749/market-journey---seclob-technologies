import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:master_journey/screens/members/members_page.dart';
import 'package:master_journey/services/package_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../navigation/bottom_tabs_screen.dart';
import '../../../resources/color.dart';

import '../../../services/member_service.dart';
import '../../../support/logger.dart';

class AddMemberPage extends StatefulWidget {
  const AddMemberPage({super.key});

  @override
  State<AddMemberPage> createState() => _AddMemberPageState();
}

class _AddMemberPageState extends State<AddMemberPage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController dobController = TextEditingController();

  var userid;
  var packagedata;
  var states;
  var districts;
  var notdistricts;
  var zonals;
  var notzonals;
  var panchayaths;

  bool _isLoading = false;

  int? dob;

  String packageAmount = '';
  String packageAmountGST = '';

  List<Map<String, dynamic>> packageData = [];
  String? packageTypedropdownvalue;
  List<String> packageType = [];

  String? packageNamedropdownvalue;
  List<String> packageName = [];

  String? stateTypedropdownvalue;
  List<String> stateType = [];

  String? districtTypedropdownvalue;
  List<String> districtType = [];
  List<String> notdistrictType = [];

  String? zonalTypedropdownvalue;
  List<String> zonalType = [];
  List<String> notzonalType = [];

  String? panchayathTypedropdownvalue;
  List<String> panchayathType = [];

  Future<void> _PackageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');

    try {
      var response = await PackageService.ViewPackage();
      log.i('Profile data show.... $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'Packages retrieved successfully') {
        setState(() {
          packageData =
          List<Map<String, dynamic>>.from(response['packageData']);

          // Extract package types and remove duplicates
          packageType = packageData
              .map((packagedata) => packagedata['franchiseName'] as String)
              .toSet()
              .toList();
          log.i('Package data names extracted: $packageType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching package data: $e');
    }
  }

  Future _Memberstate() async {
    try {
      var response = await MemberService.Memberstate();
      log.i('State API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'States retrieved successfully') {
        setState(() {
          states = response;
          stateType = List<String>.from(
              states['states'].map((state) => state['stateName']));
          log.i('State names extracted: $stateType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching states: $e');
    }
  }

  Future<void> _Memberdistrict(String stateId) async {
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
          districtType = List<String>.from(
              districts.map((district) => district['name']).toSet().toList());
          log.i('District names extracted: $districtType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching districts: $e');
    }
  }

  Future<void> _Membernotdistrict(String stateId) async {
    try {
      var response = await MemberService.Membernotdistrict(stateId);
      log.i('notDistrict API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'Districts retrieved successfully') {
        // Updated condition
        setState(() {
          notdistricts = response['districts'];

          // Extract district names and remove duplicates
          notdistrictType = List<String>.from(notdistricts
              .map((notdistrict) => notdistrict['name'])
              .toSet()
              .toList());
          log.i('District names extracted: $notdistrictType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching districts: $e');
    }
  }

  Future<void> _Memberzonal(String districtId) async {
    try {
      var response = await MemberService.Memberzonal(districtId);
      log.i('Zonal API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'Zonals retrieved successfully') {
        setState(() {
          zonals = response['zonals'];

          // Extract zonal names and remove duplicates
          zonalType = List<String>.from(
              zonals.map((zonal) => zonal['name']).toSet().toList());
          log.i('Zonal names extracted: $zonalType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching zonals: $e');
    }
  }

  ///notZonal
  Future<void> _Membernotzonal(String districtId) async {
    try {
      var response = await MemberService.Membernotzonal(districtId);
      log.i('Zonal API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'Zonals retrieved successfully') {
        setState(() {
          notzonals = response['zonals'];

          // Extract zonal names and remove duplicates
          notzonalType = List<String>.from(
              notzonals.map((zonal) => zonal['name']).toSet().toList());
          log.i('Zonal names extracted: $notzonalType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching zonals: $e');
    }
  }

  Future<void> _Memberpanchayath(String zonalId) async {
    try {
      var response = await MemberService.Memberpanchayath(zonalId);
      log.i('Panchayath API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'panchayaths retrieved successfully') {
        setState(() {
          panchayaths = response['panchayaths'];

          // Extract Panchayath names and remove duplicates
          panchayathType = List<String>.from(panchayaths
              .map((panchayath) => panchayath['name'])
              .toSet()
              .toList());
          log.i('Panchayath names extracted: $panchayathType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching panchayaths: $e');
    }
  }

  Future<void> _addMember() async {
    setState(() {
      _isLoading = true;
    });

    // Validate required fields
    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty ||
        packageTypedropdownvalue == null ||
        packageTypedropdownvalue!.isEmpty ||
        packageNamedropdownvalue == null ||
        packageNamedropdownvalue!.isEmpty ||
        stateTypedropdownvalue == null ||
        stateTypedropdownvalue!.isEmpty ||
        districtTypedropdownvalue == null ||
        districtTypedropdownvalue!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Prepare request data
      var reqData = {
        'name': nameController.text,
        'email': emailController.text,
        'phone': int.tryParse(phoneController.text) ?? 0, // Convert phone to integer
        'DateOfBirth': dobController.text, // Ensure dob is in the correct format
        'address': addressController.text,
        'password': passwordController.text,
        'packageType': packageTypedropdownvalue,
        'franchise': packageNamedropdownvalue,
        'packageAmount': packageAmount,
        'packageAmountGST': packageAmountGST,
        'state': stateTypedropdownvalue,
        if (packageNamedropdownvalue == 'Zonal Franchise')
          'franchiseName': zonalTypedropdownvalue,
        if (packageNamedropdownvalue != 'Zonal Franchise')
          'zonal': zonalTypedropdownvalue,
        if (packageNamedropdownvalue == 'District Franchise')
          'franchiseName': districtTypedropdownvalue,
        if (packageNamedropdownvalue != 'District Franchise')
          'district': districtTypedropdownvalue,
        if (packageNamedropdownvalue == 'Mobile Franchise')
          'franchiseName': panchayathTypedropdownvalue,
        if (packageNamedropdownvalue != 'Mobile Franchise')
          'panchayath': panchayathTypedropdownvalue,
      };


      log.i('Request Data: $reqData');

      var response = await MemberService.AddMember(reqData);
      if (response['sts'] == '01') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add member success')),
        );
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => BottomTabsScreen(initialPageIndex: 2,)),
        );
      } else {
        log.e('Add member failed: ${response['msg']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add member failed: ${response['msg']}')),
        );
      }
    } catch (error) {
      log.e('Error adding member: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('User already exist!')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _updatePackageAmountAndGST(String? newVal) {
    setState(() {
      packageNamedropdownvalue = newVal;

      if (packageNamedropdownvalue != null) {
        // Fetch the selected package data
        var selectedPackage = packageData.firstWhere((packagedata) =>
        packagedata['packageName'] == packageNamedropdownvalue);

        // Set the package amount
        packageAmount = selectedPackage['packageAmount'].toString();

        // Calculate the GST (18%)
        double amount = double.parse(packageAmount);
        packageAmountGST = (amount + amount * 0.18).toStringAsFixed(2);
      } else {
        packageAmount = '';
        packageAmountGST = '';
      }
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _PackageData(),
        _Memberstate(),
      ],
    );
    _isLoading = false;
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
        title: Text("Member", style: TextStyle(color: black, fontSize: 16)),
        centerTitle: true,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
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
                  hintText: 'Enter your username',
                  hintStyle: TextStyle(
                      color: marketbgblue, fontWeight: FontWeight.w400),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child:
                Text('Email', style: TextStyle(color: marketbgblue)),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your email',
                  hintStyle: TextStyle(
                      color: marketbgblue, fontWeight: FontWeight.w400),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Phone',
                    style: TextStyle(color: marketbgblue),
                  )),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter
                      .digitsOnly // Allow only numbers
                ],
                decoration: InputDecoration(
                  hintText: 'Enter your phone',
                  hintStyle: TextStyle(
                      color: marketbgblue, fontWeight: FontWeight.w400),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Address',
                    style: TextStyle(color: marketbgblue),
                  )),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: addressController,
                decoration: InputDecoration(
                  hintText: 'Enter your address',
                  hintStyle: TextStyle(
                      color: marketbgblue, fontWeight: FontWeight.w400),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Date of birth',
                    style: TextStyle(color: marketbgblue),
                  )),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: dobController,
                readOnly: true,
                keyboardType: TextInputType.datetime,
                decoration: InputDecoration(
                    hintText: 'Enter your dob',
                    hintStyle: TextStyle(
                        color: marketbgblue, fontWeight: FontWeight.w400),
                    contentPadding: EdgeInsets.symmetric(
                        vertical: 10, horizontal: 10),
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
                    suffixIcon: Icon(Icons.calendar_month)
                  // icon: Icon(Icons.calendar_month)
                ),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime(2101),
                  );

                  if (pickedDate != null) {
                    dobController.text =
                    "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                  }
                },
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child:
                Text('Package Type', style: TextStyle(color: bluem)),
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
                      hintText: 'Select Package Type',
                      hintStyle: TextStyle(fontSize: 12, color: bluem),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 10,
                    style: TextStyle(fontSize: 15),
                    items: packageType.map((String packagedata) {
                      return DropdownMenuItem<String>(
                        value: packagedata,
                        child: Text(
                          packagedata,
                          style: TextStyle(fontSize: 12, color: bluem),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      setState(() {
                        packageTypedropdownvalue = newVal;
                        packageNamedropdownvalue = null;
                        packageAmount = '';
                        packageAmountGST = '';
                        if (packageTypedropdownvalue != null) {
                          // Filter package names based on selected package type
                          packageName = packageData
                              .where((packagedata) =>
                          packagedata['franchiseName'] ==
                              packageTypedropdownvalue)
                              .map((packagedata) =>
                          packagedata['packageName'] as String)
                              .toList();
                        } else {
                          packageName = [];
                        }
                      });
                    },
                    value: packageTypedropdownvalue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child:
                Text('Package Name', style: TextStyle(color: bluem)),
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
                      hintText: 'Select Package Name',
                      hintStyle: TextStyle(fontSize: 12, color: bluem),
                    ),
                    isExpanded: true,
                    icon: Icon(Icons.arrow_drop_down),
                    iconSize: 20,
                    elevation: 10,
                    style: TextStyle(fontSize: 15),
                    items: packageName.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          item,
                          style: TextStyle(fontSize: 12, color: bluem),
                        ),
                      );
                    }).toList(),
                    onChanged: (String? newVal) {
                      _updatePackageAmountAndGST(newVal);
                    },
                    value: packageNamedropdownvalue,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                alignment: Alignment.topLeft,
                child: Text('Package Amount',
                    style: TextStyle(color: bluem)),
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Package amount',
                  hintStyle: TextStyle(
                      color: bluem, fontWeight: FontWeight.w400),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    packageAmount = text;
                  });
                },
                style: TextStyle(
                    color: bluem,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                controller: TextEditingController(text: packageAmount),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text('Package Amount GST',
                      style:
                      TextStyle(color: marketbgblue, fontSize: 14))),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: 'Package amount GST',
                  hintStyle: TextStyle(
                      color: marketbgblue, fontWeight: FontWeight.w400),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow),
                  ),
                ),
                onChanged: (text) {
                  setState(() {
                    packageAmountGST = text;
                  });
                },
                style: TextStyle(
                    color: bluem,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
                controller: TextEditingController(text: packageAmountGST),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Column(children: [
              if (packageNamedropdownvalue == 'District Franchise' ||
                  packageNamedropdownvalue == 'Zonal Franchise' ||
                  packageNamedropdownvalue == 'Mobile Franchise' ||
                  packageTypedropdownvalue == 'Courses' ||
                  packageTypedropdownvalue == 'Signals') ...[
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
                            borderSide:
                            BorderSide(color: yellow, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: yellow),
                          ),
                          hintText: 'Select State',
                          hintStyle:
                          TextStyle(fontSize: 12, color: bluem),
                        ),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        elevation: 10,
                        style: TextStyle(fontSize: 15),
                        items: stateType.map((String state) {
                          return DropdownMenuItem<String>(
                            value: state,
                            child: Text(
                              state,
                              style:
                              TextStyle(fontSize: 12, color: bluem),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            stateTypedropdownvalue = newVal;
                            districtTypedropdownvalue = null;
                            zonalTypedropdownvalue = null;
                            districtType = [];
                            notdistrictType = [];
                            zonalType = [];
                            notzonalType = [];
                            if (stateTypedropdownvalue != null) {
                              // Find the state ID corresponding to the selected state name
                              String selectedStateId = states['states']
                                  .firstWhere((state) =>
                              state['stateName'] ==
                                  stateTypedropdownvalue)['id'];
                              if (packageNamedropdownvalue ==
                                  'District Franchise') {
                                _Membernotdistrict(selectedStateId);
                              } else {
                                _Memberdistrict(selectedStateId);
                              }
                            }
                          });
                        },
                        value: stateTypedropdownvalue,
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
                            borderSide:
                            BorderSide(color: yellow, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: yellow),
                          ),
                          hintText: 'Select District',
                          hintStyle:
                          TextStyle(fontSize: 12, color: bluem),
                        ),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        elevation: 10,
                        style: TextStyle(fontSize: 15),
                        items: (packageNamedropdownvalue ==
                            'District Franchise'
                            ? notdistrictType
                            : districtType)
                            .map((String district) {
                          return DropdownMenuItem<String>(
                            value: district,
                            child: Text(
                              district,
                              style:
                              TextStyle(fontSize: 12, color: bluem),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            districtTypedropdownvalue = newVal;
                            zonalTypedropdownvalue = null;
                            zonalType = [];

                            if (districtTypedropdownvalue != null) {
                              try {
                                // Debugging: Print the API response
                                print(
                                    'Selected District: $districtTypedropdownvalue');

                                // Find the district ID corresponding to the selected district name
                                String selectedDistrictId =
                                (packageNamedropdownvalue ==
                                    'District Franchise'
                                    ? notdistricts
                                    : districts)
                                    .firstWhere((district) =>
                                district['name'] ==
                                    districtTypedropdownvalue)[
                                'id'];

                                if (packageNamedropdownvalue ==
                                    'Zonal Franchise') {
                                  _Membernotzonal(selectedDistrictId);
                                } else {
                                  _Memberzonal(selectedDistrictId);
                                }

                                print(
                                    'Selected District ID: $selectedDistrictId');
                                _Memberzonal(selectedDistrictId);
                              } catch (e) {
                                // Handle error if district is not found
                                print('Error finding district ID: $e');
                              }
                            }
                          });
                        },
                        value: districtTypedropdownvalue,
                      ),
                    ),
                  ),
                ),
              ],
              if (packageNamedropdownvalue == 'Zonal Franchise' ||
                  packageNamedropdownvalue == 'Mobile Franchise' ||
                  packageTypedropdownvalue == 'Courses' ||
                  packageTypedropdownvalue == 'Signals') ...[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Zonal',
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
                            borderSide:
                            BorderSide(color: yellow, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: yellow),
                          ),
                          hintText: 'Select Zonal',
                          hintStyle:
                          TextStyle(fontSize: 12, color: bluem),
                        ),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        elevation: 10,
                        style: TextStyle(fontSize: 15),
                        items:
                        (packageNamedropdownvalue == 'Zonal Franchise'
                            ? notzonalType
                            : zonalType)
                            .map((String zonal) {
                          return DropdownMenuItem<String>(
                            value: zonal,
                            child: Text(
                              zonal,
                              style:
                              TextStyle(fontSize: 12, color: bluem),
                            ),
                          );
                        }).toList(),


                        onChanged: (String? newVal) {
                          setState(() {
                            zonalTypedropdownvalue = newVal;
                            panchayathTypedropdownvalue = null;
                            panchayathType = [];

                            if (zonalTypedropdownvalue != null) {
                              try {
                                // Debugging: Print the API response
                                print(
                                    'Selected Zonal: $zonalTypedropdownvalue');

                                // Find the district ID corresponding to the selected district name
                                String selectedZonalId =
                                (packageNamedropdownvalue ==
                                    'Zonal Franchise'
                                    ? notzonals
                                    : zonals)
                                    .firstWhere((zonal) =>
                                zonal['name'] ==
                                    zonalTypedropdownvalue)['id'];

                                print(
                                    'Selected Zonal ID: $selectedZonalId');
                                _Memberpanchayath(selectedZonalId);
                              } catch (e) {
                                // Handle error if district is not found
                                print('Error finding Zonal ID: $e');
                              }
                            }
                          });
                        },
                        value: zonalTypedropdownvalue,
                      ),
                    ),
                  ),
                ),
              ],
              if (packageNamedropdownvalue == 'Mobile Franchise' ||
                  packageTypedropdownvalue == 'Courses' ||
                  packageTypedropdownvalue == 'Signals') ...[
                SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Text(
                      'Panchayath',
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
                            borderSide:
                            BorderSide(color: yellow, width: 1),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: yellow),
                          ),
                          hintText: 'Select Panchayath',
                          hintStyle:
                          TextStyle(fontSize: 12, color: bluem),
                        ),
                        isExpanded: true,
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 20,
                        elevation: 10,
                        style: TextStyle(fontSize: 15),
                        items: panchayathType.map((String panchayath) {
                          return DropdownMenuItem<String>(
                            value: panchayath,
                            child: Text(
                              panchayath,
                              style:
                              TextStyle(fontSize: 12, color: bluem),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newVal) {
                          setState(() {
                            panchayathTypedropdownvalue = newVal;
                          });
                        },
                        value: panchayathTypedropdownvalue,
                      ),
                    ),
                  ),
                ),
              ],
            ]),
            const SizedBox(
              height: 10,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Password',
                    style: TextStyle(color: marketbgblue),
                  )),
            ),
            SizedBox(
              height: 8,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  hintText: 'Enter your Password',
                  hintStyle: TextStyle(
                      color: marketbgblue, fontWeight: FontWeight.w400),
                  contentPadding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    borderSide: BorderSide(color: yellow),
                  ),
                ),
                style: TextStyle(
                    color: black,
                    fontSize: 12,
                    fontWeight: FontWeight.w400),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    _addMember();
                  },
                  child: Container(
                    height: 40,
                    width: 400,
                    decoration: BoxDecoration(
                        color: yellow,
                        borderRadius: BorderRadius.circular(8)),
                    child: Center(
                        child: Text(
                          'Submit',
                          style: TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        )),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      ),
    );
  }
}