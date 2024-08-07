import 'package:flutter/material.dart';

import '../../../resources/color.dart';
import '../../../services/news_service.dart';
import '../../../support/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class Latestnews extends StatefulWidget {
  const Latestnews({super.key});

  @override
  State<Latestnews> createState() => _LatestnewsState();
}

class _LatestnewsState extends State<Latestnews> {
  @override
  var newsData;


  bool _isLoading = true;

  Future<List<Map<String, dynamic>>> _NewsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var response = await NewsService.viewNews();
    log.i('News data show.... $response');
    return List<Map<String, dynamic>>.from(response[
    'newsData']); // Assuming 'newsData' contains the list of news items
  }

  Future<void> _initLoad() async {
    try {
      var response = await _NewsData();
      setState(() {
        newsData = response;
        _isLoading = false;
      });
    } catch (error) {
      print("Error loading news data: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {

      _initLoad();
    });
  }

  Widget build(BuildContext context) {
    final dateFormat = DateFormat('yyyy-MM-dd HH:mm');
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Latest News',
          style: TextStyle(color: black, fontSize: 16),
        ),
        centerTitle: true,
      ),
      backgroundColor: marketbg,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              ListView.builder(

                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: newsData != null ? newsData.length : 0,
                itemBuilder: (context, index) {
                  DateTime formattedDate =
                  DateTime.parse(newsData![index]['createdAt']);

                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 10),
                    child: Container(
                      height: 140,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: bluem,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              newsData?[index]['title'],
                              style: TextStyle(
                                color: marketbg,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(

                              dateFormat.format(formattedDate),
                              style: TextStyle(
                                color: whitegray,
                                fontWeight: FontWeight.w500,
                                fontSize: 10,
                              ),
                            ),
                            SizedBox(height: 5),
                            Expanded(
                              child: Text(
                                newsData?[index]['news'],
                                style: TextStyle(
                                  color: marketbg,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12,
                                ),
                              ),
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

