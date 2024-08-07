import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_journey/screens/bankdetails/bankdetails.dart';
import '../authentication_page/login.dart';
import '../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/changepassword/changepass.dart';
import '../screens/demateaccount/dematedetails.dart';
import '../screens/profile/profile.dart';
import '../support/logger.dart';

class appdrawer extends StatefulWidget {
  const appdrawer({super.key});

  @override
  State<appdrawer> createState() => _appdrawerState();
}

class _appdrawerState extends State<appdrawer> {
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');

    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => loginpage()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
     return SafeArea(
       child: Drawer(
        backgroundColor: bluem,
        width: 240,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(top: 130, left: 30),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ProfilePage()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Profile', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Bankdetails()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.account_balance,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Bank Details', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Dematedetails()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.account_box_outlined,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Demat account', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Changepassword()),
                  );
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Change Password',
                        style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () => _logout(context),
                child: Row(
                  children: [
                    Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Text('Logout', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            ],
          ),
        ),
           ),
     );
  }
}
Future<void> _logout(BuildContext context) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.clear();  // Clear all saved preferences

  // Navigate to login page
  Navigator.of(context).pushAndRemoveUntil(
    MaterialPageRoute(builder: (context) => loginpage()),
        (Route<dynamic> route) => false,
  );
}