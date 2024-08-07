import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:master_journey/screens/members/widgets/level_two.dart';
import 'package:master_journey/screens/report/widgets/level1.dart';
import 'package:master_journey/screens/report/widgets/level2.dart';
import 'package:master_journey/screens/report/widgets/level3.dart';
import 'package:master_journey/screens/report/widgets/level4.dart';
import 'package:master_journey/screens/report/widgets/level5.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/color.dart';

import '../../services/profile_service.dart';
import '../../support/logger.dart';
import '../members/widgets/level_one.dart';
import '../wallet/widgets/recent_transaction.dart';
import '../wallet/widgets/withdrawal_history.dart';

class report extends StatefulWidget {
  const report({super.key});

  @override
  State<report> createState() => _reportState();
}

class _reportState extends State<report> {
  String? userid;
  Map<String, dynamic>? profiledata;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      setState(() {
        userid = prefs.getString('userid');
      });
      var response = await ProfileService.profile();
      log.i('Profile data show.... $response');
      setState(() {
        profiledata = response;
      });
    } catch (error) {
      log.e('Error fetching profile data: $error');
      // Handle the error appropriately here
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: marketbg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: marketbg,
        title: Center(
          child: Text(
            "Income",
            style: TextStyle(color: black, fontSize: 18),
          ),
        ),
      ),
      body: profiledata == null
          ? Center(child: CircularProgressIndicator())
          : profiledata!['packageType'] == 'Franchise'
          ? DefaultTabController(
        length: 5, // Number of tabs
        child: Column(
          children: [
            Container(
              height: 30,
              margin: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                border: Border.all(color: bluem),
                borderRadius: BorderRadius.all(Radius.circular(7)),
                color: Colors.white,
              ),
              child: TabBar(
                indicatorSize: TabBarIndicatorSize.tab,
                indicator: BoxDecoration(
                  color: bluem,
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
                tabs: [
                  Tab(text: 'Direct'),
                  Tab(text: 'Indirect'),
                  Tab(text: 'Level Income'),
                  Tab(text: 'Autopool'),
                  Tab(text: 'Bonus'),
                ],
              ),
            ),
            SizedBox(height: 20),
            Expanded(
              child: TabBarView(
                children: [
                  LevelOneReport(),
                  LevelTwoReport(),
                  LevelThreeReport(),
                  LevelFourReport(),
                  LevelFiveReport(),
                ],
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      )
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/exclamation-mark.png', // Replace with your image path
              width: 25,
              height: 25,
            ),
            SizedBox(height: 10),
            Text(
              'You Are Not Authorized to View This Page',
              style: TextStyle(color: black, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}