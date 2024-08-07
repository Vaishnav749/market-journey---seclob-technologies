import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:master_journey/services/bank_service.dart';
import 'package:master_journey/services/profile_service.dart';
import 'package:master_journey/support/logger.dart';
import 'package:master_journey/screens/demateaccount/widget/demataccount.dart';
import 'package:master_journey/resources/color.dart';

class Dematedetails extends StatefulWidget {
  const Dematedetails({Key? key}) : super(key: key);

  @override
  State<Dematedetails> createState() => _DematedetailsState();
}

class _DematedetailsState extends State<Dematedetails> {
  var userid;
  List<dynamic> demateAccounts = [];
  Map<String, dynamic>? profiledata;

  @override
  void initState() {
    super.initState();
    _Dematedetail();
    _profileData();
  }

  Future<void> _profileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await ProfileService.profile();
      log.i('Profile data show.... $response');
      setState(() {
        profiledata = response;
      });
    } catch (e) {
      log.e('Error fetching profile data: $e');
      // Handle error appropriately, e.g., show a snackbar or a message to the user
    }
  }

  Future<void> _Dematedetail() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userid = prefs.getString('userid');
      var response = await BankService.Dematedetail();
      log.i('Demat account data show.... $response');
      setState(() {
        demateAccounts = response['demateAccounts'] ?? [];
      });
    } catch (error) {
      log.e('Error fetching demat account data: $error');
      // Handle error appropriately, e.g., show a snackbar or a message to the user
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Demat details',
          style: TextStyle(color: Colors.black, fontSize: 16),
        ),
        centerTitle: true,
        backgroundColor: marketbg,
      ),
      backgroundColor: marketbg,
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (profiledata == null) {
      return Center(child: CircularProgressIndicator());
    } else if (profiledata!['packageType'] == 'Franchise') {
      return ListView.builder(
        itemCount: demateAccounts.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildDematAccountCard(demateAccounts[index]);
        },
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/logo/exclamation-mark.png', // Replace with your image path
              height: 25,
              width: 25,
            ),
            SizedBox(height: 10),
            Text(
              'You Are Not Authorized to View This Page',
              style: TextStyle(color: Colors.black, fontSize: 12),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildDematAccountCard(Map<String, dynamic> account) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Container(
        width: 400,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: const Color.fromRGBO(206, 206, 206, 0.5)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildAccountDetailRow(
                'District', account['district'] ?? 'No Title'),
            _buildAccountDetailRow('Name', account['name'] ?? ''),
            _buildAccountDetailRow('Username', account['demateUserName'] ?? ''),
            _buildAccountDetailRow(
                'Mobile Number', account['phone'].toString()),
            _buildAccountDetailRow('Email', account['email'] ?? ''),
            _buildAccountDetailRow('Address', account['address'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildAccountDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: bluem),
          ),
          SizedBox(width: 20),
          Text(
            ":",
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: bluem),
          ),
          SizedBox(width: 20),
          Text(
            value,
            style: TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500, color: bluem),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingActionButton() {
    if (profiledata != null && profiledata!['packageType'] == 'Franchise') {
      return FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Demataccount()),
          );
        },
        child: Icon(
          Icons.add,
          color: bluem,
        ),
        backgroundColor: yellow,
      );
    } else {
      return Container(); // or use null, which is equivalent to not setting a floatingActionButton
    }
  }
}
