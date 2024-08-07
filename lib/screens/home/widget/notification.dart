import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import '../../../resources/color.dart';
import '../../../services/notification_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../support/logger.dart';
import 'package:intl/intl.dart';

class Notificationscreen extends StatefulWidget {
  const Notificationscreen({super.key});

  @override
  State<Notificationscreen> createState() => _NotificationscreenState();
}

class _NotificationscreenState extends State<Notificationscreen> {
  var userid;
  List signals = []; // Initialize as an empty list
  bool _isLoading = true;

  Future _NotificationData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');

    var response = await NotificationService.ViewNotification();
    log.i('Profile data show.... $response');

    setState(() {
      signals = response['signals'] ?? [];
    });
  }

  Future _initLoad() async {
    await _NotificationData();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _secureScreen();
    _initLoad();
  }

  @override
  void dispose() {
    _clearScreenSecurity();
    super.dispose();
  }

  void _secureScreen() {
    FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  void _clearScreenSecurity() {
    FlutterWindowManager.clearFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Notification',
          style: TextStyle(color: black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: marketbg,
      ),
      backgroundColor: marketbg,
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: signals.length,
                itemBuilder: (context, index) {
                  var signal =
                  signals[index]; // Correctly access the list element
                  var dateStr = signal['createdAt'] ?? "";
                  DateTime dateTime;
                  try {
                    dateTime = DateTime.parse(dateStr);
                  } catch (e) {
                    dateTime = DateTime.now();
                  }
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    child: Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: bluem,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          signal['title'] ?? "",
                                          style: TextStyle(
                                            color: marketbg,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                        Text(
                                          signal['description'] ?? "",
                                          style: TextStyle(
                                            color: marketbg,
                                            fontWeight: FontWeight.w500,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    dateFormat.format(dateTime),
                                    style: TextStyle(
                                      color: marketbg,
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
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
            ],
          ),
        ),
      ),
    );
  }
}