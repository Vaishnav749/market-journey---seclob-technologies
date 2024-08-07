import 'package:flutter/material.dart';
import 'package:master_journey/resources/color.dart';
import '../../../services/member_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../support/logger.dart';

class LevelOne extends StatefulWidget {
  final String id;
  const LevelOne({super.key, required this.id});

  @override
  State<LevelOne> createState() => _LevelOneState();
}

class _LevelOneState extends State<LevelOne> {
  String? userid;
  List child1 = [];
  bool _isLoading = true;

  Future _levelView(String id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');

    try {
      var response = await MemberService.Memberviewtree(id);
      log.i('Profile data show.... $response');
      setState(() {
        child1 = response['child1'] ?? [];
      });
    } catch (error) {
      log.e('Failed to load profile data: $error');
    }
  }

  Future _initLoad() async {
    await _levelView(widget.id);
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _initLoad(); // Ensure async function is awaited properly
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: child1.length,
        itemBuilder: (BuildContext context, int index) {
          final user = child1[index];
          return Padding(
            padding:
            const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: 107,
              width: 400,
              decoration: BoxDecoration(
                color: bluem,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Name",
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                        SizedBox(width: 40),
                        Text(":",
                            style:
                            TextStyle(fontSize: 12, color: marketbg)),
                        SizedBox(width: 20),
                        Text(
                          user['name'] ?? '',
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Franchise",
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                        SizedBox(width: 16),
                        Text(":",
                            style:
                            TextStyle(fontSize: 12, color: marketbg)),
                        SizedBox(width: 20),
                        Text(
                          user['franchise'] ?? '',
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      children: [
                        Text(
                          "Package",
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                        SizedBox(width: 24),
                        Text(":",
                            style:
                            TextStyle(fontSize: 12, color: marketbg)),
                        SizedBox(width: 20),
                        Text(
                          user['tempPackageAmount']?.toString() ??
                              user['actualPackageAmount']?.toString() ??
                              user['packageAmount']?.toString() ??
                              '',
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}