import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources/color.dart';

import '../../services/profile_service.dart';
import '../../support/logger.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  int isSelectedIndex = -1;
  var profiledata;

  bool _isLoading = false;
  double gstAmount = 0.0;
  double totalAmount = 0.0;

  Future<void> _ProfileData() async {
    var response = await ProfileService.profile();
    log.i('Profile data show.... $response');
    setState(() {
      profiledata = response;
      // Calculate gstAmount and totalAmount after profiledata is fetched
      gstAmount = profiledata['packageAmount'] * 0.18;
      totalAmount = profiledata['packageAmount'] + gstAmount;
    });
  }

  Future<void> _initLoad() async {
    setState(() {
      _isLoading = true;
    });
    await Future.wait([
      _ProfileData(),
      // Add other initialization tasks if needed
    ]);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        backgroundColor: bluem,
        appBar: AppBar(
          title: Text(
            "Profile",
            style: TextStyle(
                color: marketbg, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          centerTitle: true,
          backgroundColor: bluem,
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
            child: Column(children: [
              Column(children: [
                SizedBox(
                  height: 180,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: ListView.builder(
                        itemCount: 1,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (BuildContext context, int index) {
                          return Row(children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 170,
                                height: 86,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(221, 228, 235, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(19),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset('assets/svg/cash.svg'),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(children: [
                                        Text(
                                          "₹${profiledata['directIncome']}  "
                                              "",
                                          style: TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 11),
                                        ),
                                        Text('Direct Income')
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 170,
                                height: 86,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(221, 228, 235, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(19),
                                  child: Row(
                                    children: [
                                      Center(
                                        child: SvgPicture.asset(
                                          'assets/svg/cash.svg',
                                          width: 17,
                                          height: 17,
                                        ),
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(children: [
                                        Text(
                                            '₹${profiledata['inDirectIncome']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11)),
                                        Text('InDirect Income')
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 168,
                                height: 86,
                                decoration: BoxDecoration(
                                    color: Color.fromRGBO(221, 228, 235, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Padding(
                                  padding: const EdgeInsets.all(19),
                                  child: Row(
                                    children: [
                                      SvgPicture.asset(
                                        'assets/svg/cash.svg',
                                        width: 17,
                                        height: 17,
                                      ),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Column(children: [
                                        Text(
                                            '₹${profiledata['totalLevelIncome']}',
                                            style: TextStyle(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 11)),
                                        Text('Level Income')
                                      ]),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ]);
                        }),
                  ),
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Container(
                        width: double.infinity,
                        height: height,
                        decoration: BoxDecoration(
                            color: marketbg,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(60),
                              topRight: Radius.circular(60),
                            )),
                      ),
                    ),
                    Column(children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: CircleAvatar(
                          backgroundColor: marketbg,
                          radius: 50,
                          child: CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 45,
                          ),
                        ),
                      ),

                      Text(
                        profiledata['name'] ?? '',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        profiledata['userStatus'] ?? '',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: greendark,
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelectedIndex = 0;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 21),
                                height: 29,
                                width: 115,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: yellow1, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: isSelectedIndex == 0
                                      ? yellow
                                      : Colors.white,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      'Certificate',
                                      style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w500),
                                    ),
                                    SizedBox(width: 8),
                                    SvgPicture.asset(
                                        'assets/svg/up_arrow.svg'),
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  isSelectedIndex = 1;
                                });
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 37),
                                height: 29,
                                width: 115,
                                decoration: BoxDecoration(
                                  border:
                                  Border.all(color: yellow1, width: 1),
                                  borderRadius: BorderRadius.circular(5),
                                  color: isSelectedIndex == 1
                                      ? yellow
                                      : Colors.white,
                                ),
                                child: Text(
                                  'Invoice',
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // SizedBox(height: 20),
                      isSelectedIndex == -1
                          ? Padding(
                        padding:
                        const EdgeInsets.symmetric(horizontal: 24),
                        child: Container(
                          padding: EdgeInsets.all(20),
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/mail_icon.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Email : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata['email']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/phone.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Phone : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata['phone']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/location.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Address :  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Expanded(
                                      child: Text(
                                        '${profiledata['address']}',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                            color: marketbgblue),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/user_id.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'User ID : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata['ownSponserId']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/user_id.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Package Amount : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata != null ? profiledata['packageAmount'] ?? '' : ''}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/amount.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Franchise Name : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata['franchise']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/edit.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Package Type :  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata['packageType']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/user_id.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Wallet Amount : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata['walletAmount']}  ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                                SizedBox(height: 27),
                                Row(
                                  children: [
                                    SvgPicture.asset(
                                        'assets/svg/rank.svg'),
                                    SizedBox(width: 10),
                                    Text(
                                      'Pool Rank : ',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    ),
                                    SizedBox(width: 5),
                                    Text(
                                      '${profiledata['pool']}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbgblue),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                          : isSelectedIndex == 0
                          ? Container(
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Text('Certificate'),
                            Stack(
                              alignment: Alignment.center,
                              children: [
                                Image.asset(
                                  'assets/logo/Certificate.png',
                                  height: 250,
                                ),
                                Positioned(
                                  bottom:
                                  140, // Position the text where you want
                                  child: Text(
                                    profiledata['name']
                                        ?.toUpperCase() ??
                                        '',
                                    style: TextStyle(
                                      color: black,
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                      // Optional background color for better readability
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom:
                                  100, // Position the text where you want
                                  child: Container(
                                    width:
                                    250, // Match the width of the image
                                    child: RichText(
                                      textAlign: TextAlign.center,
                                      text: TextSpan(
                                        text:
                                        'This Certificate is proudly presented for the Membership of ',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 8,
                                        ),
                                        children: <TextSpan>[
                                          TextSpan(
                                            text:
                                            '${profiledata['franchise']}',
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.bold,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            ' Market Journey. We welcome you warmly into our community and look forward to your active participation and valuable contributions.',
                                            style: TextStyle(
                                              fontWeight:
                                              FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                          : Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 24),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment
                                  .start, // Align to top
                              children: [
                                BarcodeWidget(
                                  barcode: Barcode
                                      .code128(), // Example barcode type
                                  data: profiledata[
                                  'id'], // Replace with actual barcode data
                                  width: 100,
                                  height: 28,
                                  drawText:
                                  false, // Whether to draw text (default: false)
                                ),
                                Image.asset(
                                  'assets/logo/logorebrand.png',
                                  height: 56,
                                ),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Column(
                                crossAxisAlignment:
                                CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    '(+91)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400),
                                  ),
                                  Text(
                                    'Marketjourney.com',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400),
                                  ),
                                  Text(
                                    '1st Floor Hibon Plaza Mavoor Road',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight:
                                        FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 32),
                            Text(
                              'INVOICE',
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff477CC1)),
                            ),
                            SizedBox(height: 21),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                              ),
                              height: 24,
                              width: double.infinity,
                              decoration:
                              BoxDecoration(color: whitegray),
                              child: Center(
                                child: Table(
                                  children: const [
                                    TableRow(
                                      children: [
                                        Text("Amount",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: 12)),
                                        Center(
                                          child: Text("Amount",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 12)),
                                        ),
                                        Align(
                                          alignment:
                                          Alignment.topRight,
                                          child: Text("Status",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: 12)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 16),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15),
                              child: Column(
                                children: [
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Text(
                                            profiledata[
                                            'packageType'],
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 11,
                                                color:
                                                marketbgblue),
                                          ),
                                          Center(
                                            child: Text(
                                              profiledata[
                                              'franchise'],
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.topRight,
                                            child: Text(
                                              '${profiledata != null ? profiledata['packageAmount'] ?? '' : ''}',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Text(
                                            'GST',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 11,
                                                color:
                                                marketbgblue),
                                          ),
                                          Center(
                                            child: Text(
                                              '18%',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.topRight,
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Text(
                                            'GST Amount',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 11,
                                                color:
                                                marketbgblue),
                                          ),
                                          Center(
                                            child: Text(
                                              '$gstAmount',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.topRight,
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Table(
                                    children: [
                                      TableRow(
                                        children: [
                                          Text(
                                            'Package Amount',
                                            style: TextStyle(
                                                fontWeight:
                                                FontWeight.w500,
                                                fontSize: 11,
                                                color:
                                                marketbgblue),
                                          ),
                                          Center(
                                            child: Text(
                                              '${profiledata != null ? profiledata['packageAmount'] ?? '' : ''}',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                          Align(
                                            alignment:
                                            Alignment.topRight,
                                            child: Text(
                                              '',
                                              style: TextStyle(
                                                  fontWeight:
                                                  FontWeight
                                                      .w500,
                                                  fontSize: 11,
                                                  color:
                                                  marketbgblue),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 17),
                            Divider(),
                            SizedBox(height: 17),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 2),
                              height: 24,
                              width: double.infinity,
                              decoration:
                              BoxDecoration(color: whitegray),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Total',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: marketbgblue),
                                  ),
                                  Spacer(),
                                  Text(
                                    '₹ $totalAmount',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: marketbgblue),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 47),
                            Row(
                              children: [
                                Text(
                                  'Name: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: black),
                                ),
                                Text(
                                  profiledata['name'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: black),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Contact: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: black),
                                ),
                                Text(
                                  profiledata['phone'].toString(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: black),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Text(
                                  'Email: ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: black),
                                ),
                                Text(
                                  profiledata['email'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 11,
                                      color: black),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ]),
                  ],
                )
              ]),
            ])));
  }
}