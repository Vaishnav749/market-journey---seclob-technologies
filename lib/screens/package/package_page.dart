import 'package:flutter/material.dart';
import 'package:master_journey/services/package_service.dart';
import 'package:master_journey/support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/color.dart';

class package extends StatefulWidget {
  const package({super.key});

  @override
  State<package> createState() => _packageState();
}

class _packageState extends State<package> {
  var userid;
  List<dynamic>? franchisePackages;
  List<dynamic>? signalPackages;
  List<dynamic>? coursePackages;

  bool _isLoading = true;

  Future _PackageData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');

    var response = await PackageService.ViewPackage();

    log.i('Profile data show.... $response');

    setState(() {
      franchisePackages = response['packageData']
          .where((package) => package['franchiseName'] == 'Franchise')
          .toList();
      signalPackages = response['packageData']
          .where((package) => package['franchiseName'] == 'Signals')
          .toList();
      coursePackages = response['packageData']
          .where((package) => package['franchiseName'] == 'Courses')
          .toList();
      _isLoading = false;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _PackageData(),
        ///////
      ],
    );
    _isLoading = false;
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
      backgroundColor: marketbg,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: marketbg,
        title: Center(
          child: Text(
            "Package",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(
        strokeWidth: 6.0,
        valueColor: AlwaysStoppedAnimation(yellow),
      ),)
          : SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 25),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 24, bottom: 10),
                  child: Text(
                    "Franchise",
                    style: TextStyle(
                      color: Color(0xff163A56),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: franchisePackages != null
                        ? franchisePackages?.length
                        : 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 0, vertical: 10),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: bluem,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Franchise Package',
                                      style: TextStyle(
                                        color: marketbg,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Package Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbg),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      franchisePackages?[index]
                                      ['packageName'],
                                      style: TextStyle(
                                        color: yellow,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                        franchisePackages?[index]
                                        ['packageAmount'],
                                        style: TextStyle(color: yellow)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Courses',
                  style: TextStyle(
                    color: Color(0xff163A56),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                    coursePackages != null ? coursePackages?.length : 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: bluem,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 20,
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Franchise Package',
                                      style: TextStyle(
                                        color: marketbg,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Package Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbg),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      coursePackages?[index]['packageName'],
                                      style: TextStyle(
                                          color: yellow, fontSize: 12),
                                    ),
                                    Text(
                                        coursePackages?[index]
                                        ['packageName'],
                                        style: TextStyle(color: yellow)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'Signals',
                  style: TextStyle(
                    color: Color(0xff163A56),
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount:
                    signalPackages != null ? signalPackages?.length : 0,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Container(
                          height: 80,
                          decoration: BoxDecoration(
                            color: bluem,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Padding(
                            padding:
                            const EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      'Franchise Package',
                                      style: TextStyle(
                                        color: marketbg,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Spacer(),
                                    Text(
                                      'Package Amount',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12,
                                          color: marketbg),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      signalPackages?[index]['packageName'],
                                      style: TextStyle(
                                        color: yellow,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Text(
                                        signalPackages?[index]
                                        ['packageAmount'],
                                        style: TextStyle(color: yellow)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ])),
    );
  }
}