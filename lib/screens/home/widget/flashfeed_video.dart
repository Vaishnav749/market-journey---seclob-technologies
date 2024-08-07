import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../resources/color.dart';
import '../../../services/home_service.dart';
import '../../../support/logger.dart';
import 'package:url_launcher/url_launcher.dart';

class Flashfeedvideo extends StatefulWidget {
  const Flashfeedvideo({super.key});

  @override
  State<Flashfeedvideo> createState() => _FlashfeedvideoState();
}

class _FlashfeedvideoState extends State<Flashfeedvideo> {
  var userid;

  dynamic homeVideoData;
  bool _isLoading = true;

  Future<void> _getVideoFeed() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');
    var response = await homeservice.viewVideoFeeds();
    log.i('Video data: $response');
    setState(() {
      homeVideoData = response;
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _getVideoFeed(),
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
              if (homeVideoData != null &&
                  homeVideoData['homeVideoData'] != null)
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: homeVideoData['homeVideoData']?.length,
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
                                      child: GestureDetector(
                                        onTap: () async {
                                          final url = homeVideoData[
                                          'homeVideoData'][index]
                                          ['videoLink'];
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
                                          errorBuilder: (context, error,
                                              stackTrace) {
                                            return Icon(Icons.error,
                                                color: Colors.red);
                                          },
                                        ),
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
                                          homeVideoData['homeVideoData']
                                          [index]['videoTitle'] ??
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