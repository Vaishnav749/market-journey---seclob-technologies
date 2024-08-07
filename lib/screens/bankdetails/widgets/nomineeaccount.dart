import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/bank_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

class Nomineeaccount extends StatefulWidget {
  const Nomineeaccount({Key? key}) : super(key: key);

  @override
  State<Nomineeaccount> createState() => _NomineeaccountState();
}

class _NomineeaccountState extends State<Nomineeaccount> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController pancardNumController = TextEditingController();
  TextEditingController aadhaarNumController = TextEditingController();
  TextEditingController bankNameController = TextEditingController();
  TextEditingController accountNumController = TextEditingController();
  TextEditingController ifscCodeController = TextEditingController();

  String? userId;
  bool _isLoading = false;
  bool _isEditing = false;
  bool _hasNomineeDetails = false;

  @override
  void initState() {
    super.initState();
    _fetchnomineeDetails();
    ifscCodeController.addListener(() {
      ifscCodeController.value = ifscCodeController.value.copyWith(
        text: ifscCodeController.text.toUpperCase(),
        selection: ifscCodeController.selection,
      );
    });
  }

  Future<void> _fetchnomineeDetails() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var response = await ProfileService.profile();
      if (response != null && response['sts'] == '01') {
        var nomineeDetails = response['nomineeDetails'];
        if (nomineeDetails != null) {
          setState(() {
            nameController.text = nomineeDetails['name'];
            phoneController.text = nomineeDetails['phone'];
            addressController.text = nomineeDetails['address'];
            pancardNumController.text = nomineeDetails['pancardNum'];
            aadhaarNumController.text = nomineeDetails['aadhaarNum'];
            bankNameController.text = nomineeDetails['bankName'];
            accountNumController.text = nomineeDetails['accountNum'];
            ifscCodeController.text = nomineeDetails['ifscCode'];
            _hasNomineeDetails = true;
          });
        } else {
          setState(() {
            _hasNomineeDetails = false;
          });
        }
      } else {
        log.e('Fetch bank details failed: ${response['msg']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Fetch bank details failed')),
        );
      }
    } catch (error) {
      log.e('Error fetching bank details: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Add Nominee Account')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _Nominee() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userid');
    setState(() {
      _isLoading = true;
    });

    // Extract text values from controllers
    String name = nameController.text;
    String phone = phoneController.text;
    String address = addressController.text;
    String pancardNum = pancardNumController.text;
    String aadhaarNum = aadhaarNumController.text;
    String bankName = bankNameController.text;
    String accountNum = accountNumController.text;
    String ifscCode = ifscCodeController.text;

    if (name.isEmpty ||
        phone.isEmpty ||
        address.isEmpty ||
        pancardNum.isEmpty ||
        aadhaarNum.isEmpty ||
        bankName.isEmpty ||
        accountNum.isEmpty ||
        ifscCode.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var reqData = {
      'name': name,
      'phone': phone,
      'address': address,
      'pancardNum': pancardNum,
      'aadhaarNum': aadhaarNum,
      'bankName': bankName,
      'accountNum': accountNum,
      'ifscCode': ifscCode,
    };
    log.i('Request Data: $reqData');
    try {
      var response = await BankService.Nominee(reqData);
      if (response['sts'] == '01') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bank data added successfully')),
        );
        setState(() {
          _hasNomineeDetails = true;
          _isEditing = false;
        });
      } else {
        log.e('Add bank failed: ${response['msg']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Add bank failed: ${response['msg']}')),
        );
      }
    } catch (error) {
      log.e('Error adding bank: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error adding bank: $error')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter> inputFormatters = const [],
    bool enabled = true,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(color: marketbgblue, fontSize: 14),
          ),
          SizedBox(height: 10),
          TextField(
            controller: controller,
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
              hintText: hintText,
            ),
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            style: TextStyle(
                color: black, fontSize: 12, fontWeight: FontWeight.w400),
            enabled: enabled,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    pancardNumController.dispose();
    aadhaarNumController.dispose();
    bankNameController.dispose();
    accountNumController.dispose();
    ifscCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: marketbg,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _hasNomineeDetails
          ? SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 10),
            _buildTextField(
              label: 'Name',
              hintText: 'Enter your name',
              controller: nameController,
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Phone',
              hintText: 'Enter your phone',
              controller: phoneController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // Allow only numbers
              ],
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Address',
              hintText: 'Enter your bank name',
              controller: addressController,
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Adhaar Number',
              hintText: 'Enter your bank name',
              controller: aadhaarNumController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // Allow only numbers
              ],
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Pancard Number',
              hintText: 'Enter your bank name',
              controller: pancardNumController,
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Bank Name',
              hintText: 'Enter your bank name',
              controller: bankNameController,
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'Account Number',
              hintText: 'Enter your account number',
              controller: accountNumController,
              keyboardType: TextInputType.number,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter
                    .digitsOnly // Allow only numbers
              ],
              enabled: _isEditing,
            ),
            _buildTextField(
              label: 'IFSC Code',
              hintText: 'Enter your IFSC code',
              controller: ifscCodeController,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                    RegExp(r'[A-Z0-9]')),
                LengthLimitingTextInputFormatter(
                    11), // IFSC code is typically 11 characters
              ],
              enabled: _isEditing,
            ),
            SizedBox(height: 30),
            _isEditing
                ? Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: _Nominee,
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            )
                : Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 20),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isEditing = true;
                    });
                  },
                  child: Container(
                    height: 40,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Update Bank Details',
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 30),
          ],
        ),
      )
          : Center(
        child: ElevatedButton(
          onPressed: () {
            setState(() {
              _isEditing = true;
              _hasNomineeDetails = true;
            });
          },
          child: Text(
            'Add Bank Details',
            style: TextStyle(color: marketbg),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: yellow,
          ),
        ),
      ),
    );
  }
}