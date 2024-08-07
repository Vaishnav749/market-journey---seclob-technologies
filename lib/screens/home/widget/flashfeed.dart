import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';

class Flashfeed extends StatefulWidget {
  const Flashfeed({super.key});

  @override
  State<Flashfeed> createState() => _FlashfeedState();
}

class _FlashfeedState extends State<Flashfeed> {
  var userid;

  dynamic homeImageData;
  bool _isLoading = true;

  Future<void> _getImageFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await homeservice.viewImageFeeds();
    log.i('Image data: $response');
    setState(() {
      homeImageData = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _getImageFeed(),
      ],
    );
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
    final screenWidth = MediaQuery.of(context).size.width;
    final imageHeight = screenWidth * 244 / 344;
    final imageWidth = screenWidth * 0.87;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flash Feed',
          style: TextStyle(color: black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: marketbg,
      ),
      backgroundColor: marketbg,
      body: _isLoading
          ? Center(
        child: CircularProgressIndicator(
          strokeWidth: 6.0,
          valueColor: AlwaysStoppedAnimation(yellow),
        ),
      )
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 24),
          child: Column(
            children: [
              if (homeImageData != null &&
                  homeImageData['homeImageData'] != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: homeImageData['homeImageData'].length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Stack(
                                children: [
                                  Container(
                                    height: imageHeight,
                                    width: imageWidth,
                                    decoration: BoxDecoration(
                                      color: bottomtabbg,
                                      borderRadius:
                                      BorderRadius.circular(10),
                                    ),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
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
                                  ),
                                  Positioned(
                                    bottom: 0,
                                    left: 0,
                                    right: 0,
                                    child: Container(
                                      height: 33,
                                      decoration: BoxDecoration(
                                        color: whitegray,
                                        borderRadius:
                                        BorderRadius.circular(5),
                                      ),
                                      child: Center(
                                        child: Text(
                                          homeImageData['homeImageData']
                                          [index]
                                          ['description'] ??
                                              "",
                                          style: TextStyle(
                                              fontSize: 10,
                                              fontWeight:
                                              FontWeight.w400),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}