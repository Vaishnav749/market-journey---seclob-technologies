import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:master_journey/screens/home/widget/renewal_package.dart';
import 'package:master_journey/screens/home/widget/renewal_package_addon.dart';
import 'package:master_journey/screens/home/widget/renewal_package_franchise.dart';
import 'package:master_journey/screens/home/widget/signaladdonplusconvert.dart';
import 'package:master_journey/services/home_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../navigation/bottom_tabs_screen.dart';
import '../../../resources/color.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';

class Subscription extends StatefulWidget {
  const Subscription({super.key});

  @override
  State<Subscription> createState() => _SubscriptionState();
}

class _SubscriptionState extends State<Subscription> {
  var userid;
  List<dynamic> subscriptionHistory = [];
  var profiledata;

  Future _ProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.profile();
    log.i('Profile data show.... $response');
    setState(() {
      profiledata = response;
    });
  }

  Future<void> _viewsub() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await homeservice.viewSubscription();
      log.i('Profile data show.... $response');
      setState(() {
        subscriptionHistory = response['subscriptionHistory'] ?? [];
      });
    } catch (error) {
      log.e('Error fetching subscription history data: $error');
    }
  }

  @override
  void initState() {
    super.initState();
    _viewsub();
    _ProfileData();
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    var screenOrientation = MediaQuery.of(context).orientation;
    bool isPortrait = screenOrientation == Orientation.portrait;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Subscription',
          style: TextStyle(color: black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: marketbg,
        automaticallyImplyLeading: false,
         leading: IconButton(
           icon: Icon(Icons.arrow_back),
           onPressed: () {
             Navigator.of(context).pushAndRemoveUntil(
               MaterialPageRoute(builder: (context) => BottomTabsScreen()),
                   (route) => false,
             ); // Navigates back to the previous page
           },
         ),

      ),
      backgroundColor: marketbg,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  height: isPortrait ? 190 : 150,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bluem,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  profiledata?['daysUntilRenewal'].toString() ?? '',
                                  style: TextStyle(
                                    fontSize: isPortrait ? 40 : 30,
                                    fontWeight: FontWeight.w700,
                                    color: marketbg,
                                  ),
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Days left",
                                  style: TextStyle(
                                    fontSize: 15,
                                    color: marketbg,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: Text(
                                "Attention! Your subscription plan is set to renew in just ${profiledata?['daysUntilRenewal'] ?? ''} days. Renew to continue enjoying all the benefits of your subscription!",
                                style: TextStyle(
                                  color: marketbg,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            GestureDetector(
                              onTap: () {
                                if (profiledata['renewalStatus'] == "true" || profiledata['packageType'] == "Courses" || profiledata['packageType'] == "Signals" || profiledata['franchise'] == "Signals"|| profiledata['franchise'] == "Signals") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Renewalpackagesignal()),
                                  );
                                } else if (profiledata['packageType'] == "Franchise") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Renewalpackageaddon()),
                                  );
                                } else if (profiledata['packageType'] == "Courses" || profiledata['packageType'] == "Signals") {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Renewalpackage()),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => Renewalpackagefranchise()),
                                  );
                                }
                              }


                              ,
                              child: Container(
                                height: 30,
                                width: 160,
                                decoration: BoxDecoration(
                                  color: yellow,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Center(
                                  child: Text(
                                    'Subscription Package',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: SvgPicture.asset(
                          'assets/svg/bgsvghome.svg',
                          height: isPortrait ? 200 : 150,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.only(left: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Renewal History",
                    style: TextStyle(
                      color: Color(0xff163A56),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Expanded(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: subscriptionHistory.length,
                  itemBuilder: (BuildContext context, int index) {
                    var transaction = subscriptionHistory[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Container(
                        height: 80,
                        width: 300,
                        decoration: BoxDecoration(
                          color: bluem,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            children: [
                              SvgPicture.asset(
                                'assets/svg/wallet.svg',
                                fit: BoxFit.none,
                              ),
                              SizedBox(width: 10),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    transaction['name'] ?? 'No Name',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: marketbg,
                                    ),
                                  ),
                                  Text(
                                    transaction['pendingPackage'] ?? 'pendingPackage',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: whitegray,
                                    ),
                                  ),
                                  Text(
                                    transaction['action'] ?? 'No action',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: whitegray,
                                    ),
                                  ),
                                ],
                              ),
                              Expanded(child: SizedBox()),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "₹${transaction['amount'] ?? '0'}",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: marketbg,
                                    ),
                                  ),
                                  Container(
                                    height: 15,
                                    width: 55,
                                    decoration: BoxDecoration(
                                      color: greenbg,
                                      borderRadius: BorderRadius.all(Radius.circular(10)),
                                    ),
                                    child: Center(
                                      child: Text(
                                        transaction['status'] ?? 'Unknown',
                                        style: TextStyle(fontSize: 8),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}