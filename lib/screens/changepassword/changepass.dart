import 'package:flutter/material.dart';
import 'package:master_journey/services/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/color.dart';
import '../../support/logger.dart';

class Changepassword extends StatefulWidget {
  const Changepassword({super.key});

  @override
  State<Changepassword> createState() => _ChangepasswordState();
}

class _ChangepasswordState extends State<Changepassword> {
  TextEditingController newTextController = TextEditingController();
  TextEditingController chnageTextController = TextEditingController();
  bool _obscurenewText = true;
  bool _obscurechangeText = true;
  bool _isLoading = false;

  var userId;

  Future<void> _changePass() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString('userid');
    setState(() {
      _isLoading = true;
    });

    if (newTextController.text.isEmpty || chnageTextController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('All fields are required')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    if (newTextController.text != chnageTextController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Passwords do not match')),
      );
      setState(() {
        _isLoading = false;
      });
      return;
    }

    var reqData = {
      'password': chnageTextController.text,
    };
    log.i('Request Data: $reqData');
    try {
      var response = await homeservice.ChangePass(reqData);
      if (response['sts'] == '01') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password Changed successfully')),
        );
        newTextController.clear();
        chnageTextController.clear();
      } else {
        log.e('Add Demat failed: ${response['msg']}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password Change failed: ${response['msg']}')),
        );
      }
    } catch (error) {
      log.e('Error Change Password: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Change Password ')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _togglechangeVisibility() {
    setState(() {
      _obscurechangeText = !_obscurechangeText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Change Password',
            style: TextStyle(color: black, fontSize: 16)),
        centerTitle: true,
        backgroundColor: marketbg,
      ),
      backgroundColor: marketbg,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Container(
                child: Image.asset(
                  'assets/logo/changepass.png',
                  height: 200,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: newTextController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_open),
                    hintText: 'Create New Password',
                    hintStyle: TextStyle(
                        color: marketbgblue, fontWeight: FontWeight.w400),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: yellow, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: yellow),
                    ),
                  ),
                  style: TextStyle(
                      color: black, fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ),
              SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  controller: chnageTextController,
                  obscureText: _obscurechangeText,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurechangeText
                            ? Icons.visibility_off
                            : Icons.visibility,
                      ),
                      onPressed: _togglechangeVisibility,
                    ),
                    hintText: 'Confirm New Password',
                    hintStyle: TextStyle(
                        color: marketbgblue, fontWeight: FontWeight.w400),
                    contentPadding:
                    EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: yellow, width: 2),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: yellow),
                    ),
                  ),
                  style: TextStyle(
                      color: black, fontSize: 12, fontWeight: FontWeight.w400),
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
                  padding:
                  EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                ),
                onPressed: _changePass,
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
                height: 30,
              )
            ],
          ),
        ),
      ),
    );
  }
}