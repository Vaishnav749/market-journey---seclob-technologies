import 'package:flutter/material.dart';
import 'package:master_journey/screens/members/widgets/dropdownbutton.dart';
import 'package:master_journey/screens/members/widgets/add_member.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../resources/color.dart';
import '../../services/profile_service.dart';
import '../../support/logger.dart';
import 'widgets/mobileview.dart';

class memberspage extends StatefulWidget {
  const memberspage({super.key});

  @override
  State<memberspage> createState() => _memberspageState();
}

class _memberspageState extends State<memberspage> {
  String? userId;
  Map<String, dynamic>? profileData;

  @override
  void initState() {
    super.initState();
    _fetchProfileData();
  }

  Future<void> _fetchProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userid');
      var response = await ProfileService.profile();
      log.i('Profile data show.... $response');
      setState(() {
        profileData = response;
      });
    } catch (e) {
      log.e('Error fetching profile data: $e');
      // Handle error appropriately, e.g., show a snackbar or a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: marketbg, // Replace with your color
      appBar: AppBar(
        backgroundColor: marketbg, // Replace with your color
        iconTheme: const IconThemeData(
          color: Colors.black, // Replace with your color
        ),
        centerTitle: true,
        title: const Text(
          "Member View",
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
      ),
      body: profileData == null
          ? const Center(child: CircularProgressIndicator())
          : profileData!['packageType'] == 'Franchise'
          ? (profileData!['isMobileFranchise'] == true
          ? Mobileview()
          : Dropdownscreen())
          : Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/exclamation-mark.png', // Replace with your image path
              height: 25,
              width: 25,
            ),
            const SizedBox(height: 10),
            const Center(
              child: Text(
                'You Are Not Authorized to View This Page',
                style: TextStyle(color: Colors.black, fontSize: 12),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton:
      profileData != null && profileData!['packageType'] == 'Franchise'
          ? FloatingActionButton(
        child: const Icon(
          Icons.add,
          color: bluem,
        ),
        backgroundColor: yellow,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AddMemberPage()),
          );
        },
      )
          : null,
    );
  }
}