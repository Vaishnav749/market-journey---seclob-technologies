import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:master_journey/authentication_page/transcation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/bottom_tabs_screen.dart';
import '../resources/color.dart';
import '../services/login_service.dart';
import '../support/logger.dart';

class loginpage extends StatefulWidget {
  const loginpage({super.key});

  @override
  State<loginpage> createState() => _LoginPageState();
}

class _LoginPageState extends State<loginpage> {
  bool hidePassword = true;
  String? email;
  String? password;
  bool isLoading = false;
  bool _isLoader = false;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });
    var reqData = {
      'email': email,
      'password': password,
    };
    try {
      var response = await LoginService.login(reqData);
      print(response);
      if (response['sts'] == '01') {
        log.i('Login Success');
        print('User ID: ${response['id']}');
        print('Token: ${response['access_token']}');
        print('Profile Status:${response['status']}');

        await _saveAndRedirectToHome(
            response['access_token'], response['id'], response['status']);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login Success'),
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Login failed: ${response['msg']}'),
        ));
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _isLoader = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Incorrect Username and password'),
      ));
      log.e('Error during login: $error');
    }
  }

  Future<void> _saveAndRedirectToHome(
      String usertoken, String userId, String status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("token", usertoken);
    await prefs.setString("userid", userId);
    await prefs.setString("status", status); // Save the status
    print("Token saved: $usertoken"); // Debug output
    print("Status saved: $status"); // Debug output

    setState(() {
      _isLoading = false;
    });

    if (status == 'pending') {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => TransactionScreen()),
        (route) => false,
      );
    } else if (status == 'readyToApprove') {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text('Your profile is not approved yet. Please try again later.'),
      ));
    } else {
      gotoHome();
    }
  }

  void gotoHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BottomTabsScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: marketbgblue,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            'assets/logo/logorebrand.png',
            width: 200,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Username",
                  style: TextStyle(color: marketbg, fontSize: 12),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: marketbg,
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(color: yellow, width: 1),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter your username',
                      hintStyle: TextStyle(
                        color: marketbgblue,
                        fontWeight: FontWeight.w400,
                      ),
                      contentPadding: EdgeInsets.all(10),
                      border: InputBorder.none,
                    ),
                    onChanged: (text) {
                      setState(() {
                        email = text;
                      });
                    },
                    style: TextStyle(
                      color: black,
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                "Password ",
                style: TextStyle(color: marketbg, fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Container(
              decoration: BoxDecoration(
                  color: marketbg,
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  border: Border.all(color: yellow, width: 1)),
              child: TextField(
                obscureText: hidePassword,
                decoration: InputDecoration(
                  hintText: 'Enter your password',
                  hintStyle: TextStyle(color: marketbgblue),
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
                  suffixIcon: IconButton(
                    icon: hidePassword
                        ? Icon(Icons.visibility_off)
                        : Icon(Icons.visibility),
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                  ),
                ),
                onChanged: (text) { 
                  setState(() {
                    password = text;
                  });
                },
                style: TextStyle(
                    color: black, fontSize: 12, fontWeight: FontWeight.w400),
              ),
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(400, 55),
                    backgroundColor: yellow,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                    ),
                  ),
                ),
                if (_isLoading) CupertinoActivityIndicator(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
