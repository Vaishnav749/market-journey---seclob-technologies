import 'package:flutter/material.dart';
import 'package:master_journey/screens/members/widgets/filtereduser.dart';
import '../../../../resources/color.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/member_service.dart';
import '../../../services/profile_service.dart';
import '../../../support/logger.dart';
import 'level_two.dart';

class Dropdownscreen extends StatefulWidget {
  @override
  State<Dropdownscreen> createState() => _DropdownscreenState();
}

class _DropdownscreenState extends State<Dropdownscreen> {
  TextEditingController searchController = TextEditingController();
  var userId;
  var profileData;
  var zonals;
  var panchayaths;

  List<String> items = [
    'All Package Type',
    'District Franchise',
    'Zonal Franchise',
    'Mobile Franchise',
    'Nifty',
    'Bank Nifty',
    'Morning Cafe',
    'Night Cafe',
    'Crude Oil'
  ];

  String? selectedItem = 'All Package Type';
  List<String> filteredItems = [];

  String? zonalItem;
  List<String> zonalType = [];

  String? panchayathItem;
  List<String> panchayathType = [];

  bool isLevelUserClicked = false;

  Future<void> _fetchProfileData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      userId = prefs.getString('userid');
      var response = await ProfileService.profile();
      log.i('Profile data show.... $response');
      setState(() {
        profileData = response;
        if (profileData != null) {
          if (profileData['franchise'] == 'Zonal Franchise' &&
              profileData['zonalFranchise'] != null) {
            _Memberpanchayath(profileData['zonalFranchise']);
          } else if (profileData['districtFranchise'] != null) {
            _Memberzonal(profileData['districtFranchise']);
          }
        }
      });
    } catch (e) {
      log.e('Error fetching profile data: $e');
    }
  }

  Future<void> _Memberzonal(String districtId) async {
    try {
      var response = await MemberService.Memberzonal(districtId);
      log.i('Zonal API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'Zonals retrieved successfully') {
        setState(() {
          zonals = response['zonals'];
          zonalType = List<String>.from(
              zonals.map((zonal) => zonal['name']).toSet().toList());
          log.i('Zonal names extracted: $zonalType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching zonals: $e');
    }
  }

  Future<void> _Memberpanchayath(String zonalId) async {
    try {
      var response = await MemberService.Memberpanchayath(zonalId);
      log.i('Panchayath API response: $response');

      if (response != null &&
          response['sts'] == '01' &&
          response['msg'] == 'panchayaths retrieved successfully') {
        setState(() {
          panchayaths = response['panchayaths'];
          panchayathType = List<String>.from(panchayaths
              .map((panchayath) => panchayath['name'])
              .toSet()
              .toList());
          log.i('Panchayath names extracted: $panchayathType');
        });
      } else {
        log.e('Unexpected API response: $response');
      }
    } catch (e) {
      log.e('Error fetching panchayaths: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    filteredItems = items.toSet().toList();
    _fetchProfileData();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      setState(() {
        filteredItems = items
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        filteredItems = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isZonalFranchiseUser =
        profileData != null && profileData['franchise'] == 'Zonal Franchise';

    return Scaffold(
      backgroundColor: marketbg,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              height: 40,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  filterSearchResults(value);
                },
                decoration: InputDecoration(
                  hintText: 'Search here...',
                  prefixIcon: Icon(Icons.search),
                  focusedBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(color: yellow)),
                  enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: yellow)),
                  contentPadding: EdgeInsets.symmetric(vertical: 10.0),
                ),
              ),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.only(right: 10.0),
              child: Container(
                height: 40,
                width: 100,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      isLevelUserClicked = !isLevelUserClicked;
                    });
                    print('TextField tapped!');
                  },
                  child: AbsorbPointer(
                    child: Align(
                      alignment: Alignment.topRight,
                      child: TextField(
                        readOnly: true,
                        decoration: InputDecoration(
                          hintText: 'LevelUser',
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                          border: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(5.0)),
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.yellow),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 12),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: DropdownButtonFormField2<String>(
                        decoration: const InputDecoration(
                          contentPadding: const EdgeInsets.only(bottom: 7),
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                            BorderRadius.all(Radius.circular(10.0)),
                            borderSide: BorderSide(color: yellow, width: 1),
                          ),
                        ),
                        isExpanded: true,
                        value: selectedItem,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        items: filteredItems
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Center(
                            child: Text(
                              item,
                              style: TextStyle(fontSize: 10),
                            ),
                          ),
                        ))
                            .toList(),
                        onChanged: (String? item) {
                          setState(() {
                            selectedItem = item;
                          });
                        },
                      ),
                    ),
                  ),
                ),
                if (!isZonalFranchiseUser) ...[
                  SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: yellow,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Center(
                        child: DropdownButtonFormField2<String>(
                          isExpanded: true,
                          value: zonalItem,
                          style: TextStyle(fontSize: 12, color: Colors.black),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.only(bottom: 7),
                            border: InputBorder.none,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide.none,
                            ),
                            hintText: 'Zonal',
                            hintStyle: TextStyle(fontSize: 10, color: bluem),
                          ),
                          items: zonalType.map((String zonal) {
                            return DropdownMenuItem<String>(
                              value: zonal,
                              child: Center(
                                child: Text(
                                  zonal,
                                  style:
                                  TextStyle(fontSize: 10.5, color: bluem),
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (String? newVal) {
                            setState(() {
                              zonalItem = newVal;
                              if (newVal != null) {
                                var selectedZonal = zonals.firstWhere(
                                        (z) => z['name'] == newVal,
                                    orElse: () => null);
                                if (selectedZonal != null) {
                                  _Memberpanchayath(selectedZonal['id']);
                                }
                              }
                            });
                          },
                        ),
                      ),
                    ),
                  ),
                ],
                SizedBox(width: 10),
                Expanded(
                  child: Container(
                    height: 40,
                    decoration: BoxDecoration(
                      color: yellow,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: DropdownButtonFormField2<String>(
                        isExpanded: true,
                        value: panchayathItem,
                        style: TextStyle(fontSize: 12, color: Colors.black),
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 7),
                          border: InputBorder.none,
                          enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                        hint: Text(
                          'Panchayath',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.black,
                          ),
                        ),
                        items: panchayathType
                            .map((item) => DropdownMenuItem<String>(
                          value: item,
                          child: Text(
                            item,
                            style: TextStyle(fontSize: 10),
                          ),
                        ))
                            .toList(),
                        onChanged: (String? item) {
                          setState(() {
                            panchayathItem = item;
                          });
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: isLevelUserClicked
                  ? LevelUser()
                  : Filtereduser(
                searchQuery: searchController.text,
                selectedFranchise: selectedItem,
                selectedZonal: zonalItem,
                selectedPanchayath: panchayathItem,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MaterialApp(
  home: Dropdownscreen(),
));