import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:master_journey/screens/home/widget/flashfeed_video.dart';
import 'package:master_journey/screens/home/widget/latestnews.dart';
import 'package:master_journey/screens/home/widget/notification.dart';
import 'package:master_journey/screens/home/widget/subscription.dart';
import '../../navigation/app_drawer.dart';
import '../../resources/color.dart';

import 'package:shared_preferences/shared_preferences.dart';
import '../../services/home_service.dart';
import '../../services/profile_service.dart';
import '../../support/logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'widget/flashfeed.dart';
import 'package:share_plus/share_plus.dart';

class home extends StatefulWidget {
  const home({super.key});

  @override
  State<home> createState() => _homeState();
}

class _homeState extends State<home> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  Timer? _timer;

  var userid;
  var profiledata;
  dynamic awardData;
  List pool1 = [];
  List pool2 = [];
  bool _isLoading = true;
  dynamic newsData;
  dynamic homeImageData;
  dynamic homeVideoData;
  bool isError = false;
  String errorMessage = '';

  Future _ProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await ProfileService.profile();
    log.i('Profile data show.... $response');
    setState(() {
      profiledata = response;
    });
  }

  Future<void> _AwardData() async {
    try {
      var response = await homeservice.viewRewards();
      log.i('Award & Reward data show.... $response');
      setState(() {
        awardData = response ?? [];
      });
    } catch (error) {
      log.e('Error fetching award data: $error');
    }
  }

  Future<void> _NewsData() async {
    try {
      var response = await homeservice.viewNews();
      log.i('Award & Reward data show.... $response');
      setState(() {
        newsData = response ?? [];
      });
    } catch (error) {
      log.e('Error fetching award data: $error');
    }
  }

  Future<void> _getImageFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await homeservice.viewImageFeeds();
    log.i('Image data: $response');
    setState(() {
      homeImageData = response;
    });
  }

  Future<void> _getVideoFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await homeservice.viewVideoFeeds();
    log.i('Video data: $response');
    setState(() {
      homeVideoData = response;
    });
  }

  Future _leadersboard() async {
    var response = await homeservice.viewleaders();
    log.i(' data show.... $response');
    setState(() {
      pool1 = response['pool'] ?? [];
    });
  }



  Future<void> _distributedleadersboard() async {
    try {
      var response = await homeservice.distributedleaders();
      log.i('Data show.... $response');
      if (response != null && response['statusCode'] == 200) {
        setState(() {
          pool2 = response['pool'] ?? [];
          isError = false;
        });
      } else if (response != null && response['statusCode'] == 404) {
        setState(() {
          isError = true;
          errorMessage = 'Auto pool distribution history not found';
        });
      } else {
        setState(() {
          isError = true;
          errorMessage = 'No data Available';
        });
      }
    } catch (e) {
      setState(() {
        isError = true;
        errorMessage = 'No data Available';
      });
      log.e('Error fetching data: $e');
    }
  }




  Future _initLoad() async {
    await Future.wait(
      [
        _ProfileData(),
        _AwardData(),
        _NewsData(),
        _leadersboard(),
        _distributedleadersboard(),
        _getImageFeed(),
        _getVideoFeed()
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
      _startAutoScroll();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(Duration(milliseconds: 100), (timer) {
      if (_scrollController.hasClients) {
        final maxScroll = _scrollController.position.maxScrollExtent;
        final currentScroll = _scrollController.offset;
        final nextScroll = currentScroll + 1.5;

        if (nextScroll >= maxScroll) {
          _scrollController.jumpTo(0.0); // Reset to the beginning if at the end
        } else {
          _scrollController.animateTo(
            nextScroll,
            duration: Duration(milliseconds: 100),
            curve: Curves.linear,
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
          backgroundColor: marketbg,
          key: _scaffoldKey,
          drawerEnableOpenDragGesture: false,
          endDrawerEnableOpenDragGesture: false,
          drawer: appdrawer(),
          body: _isLoading
              ? Center(
            child: CircularProgressIndicator(
              strokeWidth: 6.0,
              valueColor: AlwaysStoppedAnimation(yellow),
            ),
          )
              : SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: GestureDetector(
                    // onTap: () {
                    //   _scaffoldKey.currentState?.openDrawer();
                    //   // Navigator.of(context).push(MaterialPageRoute(builder: (context) => myHome()));
                    // },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () {
                            _scaffoldKey.currentState?.openDrawer();
                            // Navigator.of(context).push(MaterialPageRoute(
                            //     builder: (context) => home()));
                          },
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset(
                              'assets/svg/drawrwhite.svg',
                              color: black,
                              width: screenWidth * 0.03,
                              height: screenHeight * 0.03,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const Notificationscreen()),
                            );
                          },
                          child: SizedBox(
                            height: 30,
                            width: 30,
                            child: SvgPicture.asset(
                              'assets/svg/notifications_unread.svg',
                              width: screenWidth * 0.04,
                              height: screenHeight * 0.04,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      vertical: screenHeight * 0.03,
                      horizontal: screenWidth * 0.06),
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Hello ${profiledata['name']}',
                          style: TextStyle(
                              fontSize: screenWidth * 0.04,
                              fontWeight: FontWeight.w600),
                        ),
                        Text(
                          "Welcome Back",
                          style: TextStyle(
                              fontSize: screenWidth * 0.07,
                              fontWeight: FontWeight.w700,
                              color: marketbgblue),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Container(
                    height: screenHeight * 0.05,
                    decoration: BoxDecoration(
                      color: appBlueColor,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/svg/verified.svg',
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Text("Verified your profile"),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.02,
                        child: Divider(
                          color: black,
                        ),
                      ),
                      Text(
                        " LATEST NEWS ",
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight:
                            FontWeight.w600), // Adjust font size
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Expanded(
                        child: Divider(
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  height: 20,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    controller: _scrollController,
                    itemCount: newsData['newsData'].length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Latestnews()), // Ensure LatestNews is defined
                          );
                        },
                        child: Text(
                          "                            ${newsData['newsData'][index]['title'] ?? 'No Title'}                            ",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                            color:
                            marketbgblue, // Replace with marketbgblue if defined
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Container(
                    padding: EdgeInsets.only(left: 9, right: 6),
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: bluem,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                profiledata['daysUntilRenewal']
                                    .toString(),
                                style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w700,
                                    color: marketbg),
                              ),
                              SizedBox(
                                width: 7,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  "Days left",
                                  style: TextStyle(
                                      fontSize: 17, color: marketbg),
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  "Attention! Your subscription plan is set to renew in just  ${profiledata['daysUntilRenewal']} days. Renew to continue enjoying all the benefits of your subscription!",
                                  style: TextStyle(
                                      color: marketbg,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w400),
                                ),
                              ),
                              Image.asset(
                                'assets/logo/freemium.png',
                                height: 83,
                                width: 83,
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Subscription()),
                                );
                              },
                              child: Container(
                                height: 26,
                                width: 150,
                                decoration: BoxDecoration(
                                    color: yellow,
                                    borderRadius:
                                    BorderRadius.circular(10)),
                                child: Center(
                                    child: Text(
                                      'Subscription Package',
                                      style: TextStyle(fontSize: 10),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        height: screenHeight * 0.27,
                        width: screenWidth * 0.40,
                        decoration: BoxDecoration(
                          color: bluem,
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.025),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.05),
                          child: Column(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceEvenly,
                            children: [
                              Image.asset(
                                'assets/logo/walletimg1.png',
                                height: screenHeight * 0.08,
                                width: screenHeight * 0.08,
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "My balance",
                                  style: TextStyle(
                                    color: marketbg,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  "₹${profiledata['walletAmount']}",
                                  style: TextStyle(
                                      color: marketbg,
                                      fontSize: screenHeight * 0.02,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: screenHeight * 0.27,
                        width: screenWidth * 0.44,
                        decoration: BoxDecoration(
                          color: bluem,
                          borderRadius:
                          BorderRadius.circular(screenWidth * 0.025),
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(screenWidth * 0.025),
                          child: Column(
                            children: [
                              Image.asset(
                                'assets/logo/refferpage.png',
                                height: screenHeight *
                                    0.1, // Adjusted for responsiveness
                              ),
                              Flexible(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: screenWidth * 0.03),
                                  child: Text(
                                    "Sharing is rewarding! Refer your friends and Life Time Income",
                                    style: TextStyle(
                                      fontSize: screenHeight * 0.013,
                                      fontWeight: FontWeight.w400,
                                      color: marketbg,
                                    ),
                                    textAlign: TextAlign.left,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: screenWidth * 0.03,
                                    top: screenHeight * 0.01),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: GestureDetector(
                                    onTap: () {
                                      final url =
                                          'https://member.marketjourney.in/auth/boxed-signup/${profiledata['id']}';
                                      Share.share(url);
                                    },
                                    child: Container(
                                      height: screenHeight *
                                          0.05, // Adjusted for responsiveness
                                      width: screenWidth *
                                          0.25, // Adjusted for responsiveness
                                      decoration: BoxDecoration(
                                        color: yellow,
                                        borderRadius: BorderRadius.circular(
                                            screenWidth * 0.01),
                                      ),
                                      child: Center(
                                        child: Text(
                                          "Refer Now",
                                          style: TextStyle(
                                            fontSize: screenWidth * 0.03,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.02,
                        child: Divider(
                          color: black,
                        ),
                      ),
                      Text(
                        " Award Rewards ",
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight:
                            FontWeight.w600), // Adjust font size
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Expanded(
                        child: Divider(
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Container(
                  height: 135,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.yellow[100],
                    borderRadius: BorderRadius.all(
                      Radius.circular(screenWidth * 0.025),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: awardData['awardData']
                          .length, // Ensure itemCount matches list length
                      itemBuilder: (BuildContext context, int index) {
                        return Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.025,
                              ),
                              child: Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  ClipOval(
                                    child: Container(
                                      color: Colors.white,
                                      height: 61,
                                      width: 61,
                                      child: Image.network(
                                        'https://admin.marketjourney.in/uploads/${awardData['awardData'][index]['memberImage']}',
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.error,
                                              color: Colors.red);
                                        },
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 1),
                                  Text(
                                    awardData['awardData'][index]
                                    ['memberName'],
                                    style: TextStyle(
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.02,
                        child: Divider(
                          color: black,
                        ),
                      ),
                      Text(
                        " Leader Boards ",
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight:
                            FontWeight.w600), // Adjust font size
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Expanded(
                        child: Divider(
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    itemCount: pool1.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      var pooldata = pool1[index];
                      // Define a list of static titles
                      List<String> titles = [
                        'Team Leader (A)',
                        'Business Development Manager (B)',
                        'Regional Manager (C)',
                        'Territory Manager (D)',
                        'Associate Direction (E)',
                        // Add more titles as needed
                      ];
                      // Use the index to fetch the corresponding title
                      String title = titles.length > index
                          ? titles[index]
                          : 'Default Title';

                      return Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Container(
                          width: 200,
                          height: 88,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: marketbgblue,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Column(
                              children: [
                                Text(
                                  title, // Use the static title
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w500,
                                    color: marketbg,
                                  ),
                                ),
                                SizedBox(height: 10),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Member’s",
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                              color: marketbg,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            height: 25,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  4),
                                              color: yellow1,
                                            ),
                                            child: Center(
                                              child: Text(
                                                pooldata['count']
                                                    ?.toString() ??
                                                    "0",
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Amount",
                                            style: TextStyle(
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                              color: marketbg,
                                            ),
                                          ),
                                          SizedBox(height: 5),
                                          Container(
                                            height: 25,
                                            width: 40,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(
                                                  4),
                                              color: yellow1,
                                            ),
                                            child: Center(
                                              child: Text(
                                                pooldata['amount']
                                                    ?.toString() ??
                                                    "0",
                                                style: TextStyle(
                                                  fontWeight:
                                                  FontWeight.w500,
                                                  fontSize: 10,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.02,
                        child: Divider(
                          color: black,
                        ),
                      ),
                      Text(
                        " Distributed Leader Boards ",
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight:
                            FontWeight.w600), // Adjust font size
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Expanded(
                        child: Divider(
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: screenHeight * 0.02),
            SizedBox(
              height: 100,
              child: isError
                  ? Center(
                child: Text(
                  errorMessage,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
                  : pool2.isEmpty
                  ? Center(
                child: Text(
                  'No data available',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                ),
              )
                  : ListView.builder(
                itemCount: pool2.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  var pooldata2 = pool2[index];
                  // Define a list of static titles
                  List<String> titles = [
                    'Team Leader (A)',
                    'Business Development Manager (B)',
                    'Regional Manager (C)',
                    'Territory Manager (D)',
                    'Associate Direction (E)',
                    // Add more titles as needed
                  ];
                  // Use the index to fetch the corresponding title
                  String title = titles.length > index
                      ? titles[index]
                      : 'Default Title';

                  return Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Container(
                      width: 200,
                      height: 88,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: marketbgblue,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          children: [
                            Text(
                              title, // Use the static title
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: marketbg,
                              ),
                            ),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.only(left: 20, right: 20),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Member’s",
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: marketbg,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        height: 25,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: yellow1,
                                        ),
                                        child: Center(
                                          child: Text(
                                            pooldata2['count']?.toString() ?? "0",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Amount",
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: marketbg,
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      Container(
                                        height: 25,
                                        width: 40,
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(4),
                                          color: yellow1,
                                        ),
                                        child: Center(
                                          child: Text(
                                            pooldata2['amount']?.toString() ?? "0",
                                            style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
                  height: screenHeight * 0.04,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05),
                  child: Row(
                    children: [
                      SizedBox(
                        width: screenWidth * 0.02,
                        child: Divider(
                          color: black,
                        ),
                      ),
                      Text(
                        " FLASH FEED ",
                        style: TextStyle(
                            fontSize: screenWidth * 0.04,
                            fontWeight:
                            FontWeight.w600), // Adjust font size
                      ),
                      SizedBox(
                        width: screenWidth * 0.01,
                      ),
                      Expanded(
                        child: Divider(
                          color: black,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SizedBox(
                  height:
                  180, // Adjust height as needed, or consider removing for flexibility
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                    homeImageData['homeImageData']?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                        EdgeInsets.only(left: screenWidth * 0.05),
                        child: Column(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const Flashfeed()),
                                );
                              },
                              child: ClipRRect(
                                // Clip content that overflows
                                borderRadius: BorderRadius.circular(10),
                                child: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      height: 88,
                                      width: 122,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius:
                                        BorderRadius.circular(10),
                                      ),
                                      child: Image.network(
                                        'https://admin.marketjourney.in/uploads/${homeImageData['homeImageData'][index]['homeImage']}',
                                        fit: BoxFit.fitHeight,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.error,
                                              color: Colors.red);
                                        },
                                      ),
                                    ),
                                    // Expanded(
                                    //   child: SizedBox(
                                    //     width: 122,
                                    //     child: Text(
                                    //       homeImageData['homeImageData'][index]
                                    //               ['description'] ??
                                    //           "",
                                    //       style: TextStyle(
                                    //           fontSize: 10,
                                    //           fontWeight: FontWeight.w400,
                                    //           color: Color(0xff000080)),
                                    //     ),
                                    //   ),
                                    // ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 122,
                                child: Text(
                                  homeImageData['homeImageData'][index]
                                  ['description'] ??
                                      "",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff000080)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(
                  height:
                  180, // Adjust height as needed, or consider removing for flexibility
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount:
                    homeVideoData['homeVideoData']?.length ?? 0,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding:
                        EdgeInsets.only(left: screenWidth * 0.05),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                  const Flashfeedvideo()),
                            );
                          },
                          child: ClipRRect(
                            // Clip content that overflows
                            borderRadius: BorderRadius.circular(10),
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 88,
                                  width: 122,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[200],
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: ClipRRect(
                                    // Clip image within container
                                    borderRadius:
                                    BorderRadius.circular(10),
                                    child: GestureDetector(
                                      onTap: () async {
                                        final url =
                                        homeVideoData['homeVideoData']
                                        [index]['videoLink'];
                                        final uri = Uri.parse(url);

                                        if (await canLaunchUrl(uri)) {
                                          await launchUrl(uri,
                                              mode: LaunchMode
                                                  .externalApplication);
                                        } else {
                                          throw 'Could not launch $url';
                                        }
                                      },
                                      child: Image.network(
                                        'https://admin.marketjourney.in/uploads/${homeVideoData['homeVideoData'][index]['videoThambnail']}',
                                        fit: BoxFit.fitHeight,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          return Icon(Icons.error,
                                              color: Colors.red);
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  homeVideoData['homeVideoData'][index]
                                  ['videoTitle'] ??
                                      "",
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w400,
                                      color: Color(0xff000080)),
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
            ),
          )),
    );
  }
}