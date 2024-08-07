import 'dart:async';
import 'package:flutter/material.dart';
import 'package:master_journey/authentication_page/transcation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/bottom_tabs_screen.dart';
import '../resources/color.dart';
import 'LandingPage.dart';
import 'login.dart';
 // Import the new pending page

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    _navigateToNextPage();
  }

  Future<void> _navigateToNextPage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userToken = prefs.getString('token');
    String? responseStatus = prefs.getString('status'); // Retrieve the status

    print("Retrieved token in splash screen: $userToken"); // Debug output
    print("Retrieved status in splash screen: $responseStatus"); // Debug output

    Timer(
      Duration(seconds: 2),
          () {
        if (responseStatus == 'pending') {
          print("Status is pending, navigating to pending page."); // Debug output
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => TransactionScreen()),
          );
        } else if (userToken == null || userToken.isEmpty) {
          print("No token found, navigating to login page."); // Debug output
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => loginpage()),
          );
        } else {
          print("Token found, navigating to home page."); // Debug output
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Landing_Page(title: "Home")),
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: marketbg,
      body: Center(
        child: Image.asset(
          'assets/logo/logorebrand.png',
          width: 500, // Set the desired width
          height: 500, // Set the desired height
        ),
      ),
    );
  }
}
