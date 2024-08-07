import 'package:flutter/material.dart';
import 'package:master_journey/resources/color.dart';
import '../../../services/member_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../support/logger.dart';
import 'level_one.dart';

class Filtereduser extends StatefulWidget {
  final String searchQuery;
  final String? selectedFranchise;
  final String? selectedZonal;
  final String? selectedPanchayath;

  const Filtereduser({
    super.key,
    required this.searchQuery,
    required this.selectedFranchise,
    this.selectedZonal,
    this.selectedPanchayath,
  });

  @override
  State<Filtereduser> createState() => _FiltereduserState();
}

class _FiltereduserState extends State<Filtereduser> {
  var userid;
  var filteredUsers;
  List filteredChild1 = [];
  bool _isLoading = true;

  Future _leveview() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString('userid');

    var response = await MemberService.Memberview();
    log.i('Profile data show.... $response');
    setState(() {
      filteredUsers = response;
      _filterSearchResults(widget.searchQuery, widget.selectedFranchise,
          widget.selectedZonal, widget.selectedPanchayath);
    });
  }

  Future _initLoad() async {
    await Future.wait(
      [
        _leveview(),
      ],
    );
    _isLoading = false;
  }

  @override
  void initState() {
    super.initState();
    _initLoad();
  }

  @override
  void didUpdateWidget(Filtereduser oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.searchQuery != widget.searchQuery ||
        oldWidget.selectedFranchise != widget.selectedFranchise ||
        oldWidget.selectedZonal != widget.selectedZonal ||
        oldWidget.selectedPanchayath != widget.selectedPanchayath) {
      _filterSearchResults(widget.searchQuery, widget.selectedFranchise,
          widget.selectedZonal, widget.selectedPanchayath);
    }
  }

  void _filterSearchResults(
      String query, String? franchise, String? zonal, String? panchayath) {
    if (filteredUsers != null) {
      var results = filteredUsers['filteredUsers'];

      if (query.isNotEmpty) {
        results = results
            .where((member) =>
        member['name'].toLowerCase().contains(query.toLowerCase()) ||
            member['franchise']
                .toLowerCase()
                .contains(query.toLowerCase()) ||
            member['tempPackageAmount']
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }

      if (franchise != null && franchise != 'All Package Type') {
        results = results
            .where((member) =>
        member['franchise'].toLowerCase() == franchise.toLowerCase())
            .toList();
      }

      if (zonal != null && zonal.isNotEmpty) {
        results = results
            .where((member) =>
        member['zonal'].toLowerCase() == zonal.toLowerCase())
            .toList();
      }

      if (panchayath != null && panchayath.isNotEmpty) {
        results = results
            .where((member) =>
        member['panchayath'].toLowerCase() == panchayath.toLowerCase())
            .toList();
      }

      setState(() {
        filteredChild1 = results;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : ListView.builder(
      itemCount: filteredUsers != null ? filteredChild1.length : 0,
      itemBuilder: (BuildContext context, int index) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Container(
            width: 400,
            decoration: BoxDecoration(
              color: bluem,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                left: 20,
                top: 20,
                right: 10,
                bottom: 10,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(fontSize: 12, color: marketbg),
                      ),
                      SizedBox(width: 40),
                      Text(
                        ":",
                        style: TextStyle(fontSize: 12, color: marketbg),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          filteredChild1[index]['name'],
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Franchise",
                        style: TextStyle(fontSize: 12, color: marketbg),
                      ),
                      SizedBox(width: 16),
                      Text(
                        ":",
                        style: TextStyle(fontSize: 12, color: marketbg),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          filteredChild1[index]['franchise'],
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Text(
                        "Package",
                        style: TextStyle(fontSize: 12, color: marketbg),
                      ),
                      SizedBox(width: 24),
                      Text(
                        ":",
                        style: TextStyle(fontSize: 12, color: marketbg),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          filteredChild1[index]['tempPackageAmount'].toString(),
                          style: TextStyle(fontSize: 12, color: marketbg),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        String id = filteredChild1[index]['_id'];
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LevelOne(id: id),
                          ),
                        );
                      },
                      child: Container(
                        width: 65,
                        height: 25,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: yellow,
                        ),
                        child: Center(
                          child: Text(
                            'View Tree',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 10,
                              color: Color(0xff0F1535),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );

  }
}