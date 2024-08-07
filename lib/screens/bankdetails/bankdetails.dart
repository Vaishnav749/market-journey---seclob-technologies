import 'package:flutter/material.dart';
import 'package:master_journey/resources/color.dart';
import 'package:master_journey/screens/bankdetails/widgets/nomineeaccount.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/profile_service.dart';
import '../../support/logger.dart';
import 'widgets/bankaccount.dart';

class Bankdetails extends StatefulWidget {
  const Bankdetails({super.key});

  @override
  State<Bankdetails> createState() => _BankdetailsState();
}

class _BankdetailsState extends State<Bankdetails> {
  String? userid;
  Map<String, dynamic>? profiledata;

  @override
  void initState() {
    super.initState();
    _profileData();
  }

  Future<void> _profileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await ProfileService.profile();
      log.i('Profile data show.... $response');
      setState(() {
        profiledata = response;
      });
    } catch (e) {
      log.e('Error fetching profile data: $e');
      // Handle error appropriately, e.g., show a snackbar or a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bank details',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: marketbg,
      ),
      backgroundColor: marketbg,
      body: profiledata == null
          ? Center(child: CircularProgressIndicator())
          : profiledata!['packageType'] == 'Franchise'
          ? DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicatorPadding: EdgeInsets.symmetric(horizontal: 30),
                indicatorColor: yellow,
                dividerColor: Colors.transparent,
                labelStyle:
                TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                labelColor: black,
                unselectedLabelColor: black,
                tabs: [
                  Tab(text: 'Bank Account'),
                  // Title for first tab
                  Tab(text: 'Nominee Account'),
                ],
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: TabBarView(
                children: [Bankaccount(), Nomineeaccount()],
              ),
            )
          ],
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/exclamation-mark.png', // Replace with your image path
              height: 25,
              width: 25,
            ),
            SizedBox(height: 10),
            Center(
              child: Text(
                'You Are Not Authorized to View This Page',
                style: TextStyle(color: black, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
