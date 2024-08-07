import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:master_journey/screens/wallet/widgets/cashwithdraw.dart';
import 'package:master_journey/screens/wallet/widgets/recent_transaction.dart';
import 'package:master_journey/screens/wallet/widgets/withdrawal_history.dart';
import '../../resources/color.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../services/profile_service.dart';
import '../../support/logger.dart';

class wallet extends StatefulWidget {
  const wallet({super.key});

  @override
  State<wallet> createState() => _walletState();
}

class _walletState extends State<wallet> {
  var userid;
  var profiledata;
  dynamic awardData;
  List pool = [];
  bool _isLoading = true;

  Future _ProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.profile();
    log.i('Profile data show.... $response');
    setState(() {
      profiledata = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _ProfileData(),

        ///////
      ],
    );
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      _initLoad();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: bluem,
        title: Center(
          child:
          Text("Wallet", style: TextStyle(color: marketbg, fontSize: 18)),
        ),
        centerTitle: true,
      ),
      backgroundColor: bluem,
      body: profiledata == null
          ? Center(child: CircularProgressIndicator())
          : profiledata!['packageType'] == 'Franchise'
          ? SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Your Balance",
                    style: TextStyle(color: whitegray),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        profiledata?['walletAmount']?.toString() ??
                            '0.00',
                        style: TextStyle(
                          color: marketbg,
                          fontSize: 25,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        height: 50,
                        width: 50,
                        decoration: BoxDecoration(
                          color: whitegray,
                          borderRadius:
                          BorderRadius.all(Radius.circular(10)),
                        ),
                        child: SizedBox(
                          child: Image.asset(
                            'assets/logo/wallet.png',
                            fit: BoxFit.none,
                          ),
                        ),
                      )
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Cashwithdraw()),
                );
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40.0),
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius:
                    BorderRadius.all(Radius.circular(10)),
                  ),
                  child: Center(
                    child: Text(
                      'Request withdrawal cash',
                      style: TextStyle(
                          fontSize: 12,
                          color: black,
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 25),
            Container(
              decoration: BoxDecoration(
                color: marketbg,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text(
                      'Withdrawal History',
                      style: TextStyle(
                        color: black,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Container(
                    height: 1000, // Adjust height as needed
                    child: withdrawalhistory(),
                  ),
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
              style: TextStyle(color: marketbg, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }
}