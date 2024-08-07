import 'package:flutter/material.dart';
import 'package:master_journey/authentication_page/transcation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../navigation/bottom_tabs_screen.dart';
import 'login.dart';


class Landing_Page extends StatefulWidget {
  const Landing_Page({Key? key, required this.title}) : super(key: key);
  static String id = "Landing";
  final String title;

  @override
  _Landing_PageState createState() => _Landing_PageState();
}

class _Landing_PageState extends State<Landing_Page> {
  late Future<void> _checkAuthFuture;
  String? userToken;

  Future<void> _checkAuthenticated() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userToken = prefs.getString('token');
    String? responseStatus = prefs.getString('status'); // Retrieve the status
    print("Retrieved token: $userToken"); // Debug output
    print("Retrieved status: $responseStatus"); // Debug output

    if (responseStatus == 'pending') {
      print("Status is pending, navigating to pending page."); // Debug output
      gotoPending();
    } else if (userToken == null || userToken!.isEmpty) {
      print("No token found, navigating to login page."); // Debug output
      gotoLogin();
    } else {
      print("Token found, navigating to home page."); // Debug output
      gotoHome();
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAuthFuture = _checkAuthenticated();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: _checkAuthFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return Container();
          }
        },
      ),
    );
  }

  void gotoHome() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BottomTabsScreen()),
          (route) => false,
    );
  }

  void gotoLogin() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => loginpage()),
          (route) => false,
    );
  }

  void gotoPending() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => BottomTabsScreen()),
          (route) => false,
    );
  }
}
