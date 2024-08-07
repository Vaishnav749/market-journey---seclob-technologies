import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../resources/color.dart';
import '../screens/home/home_page.dart';
import '../screens/members/members_page.dart';
import '../screens/package/package_page.dart';
import '../screens/report/report_page.dart';
import '../screens/wallet/wallet_page.dart';
import 'app_drawer.dart';

class BottomTabsScreen extends StatefulWidget {

  final int initialPageIndex;


  const BottomTabsScreen({Key? key, this.initialPageIndex = 0}): super(key: key);

  @override
  State<BottomTabsScreen> createState() => _BottomTabsScreenState();
}

class _BottomTabsScreenState extends State<BottomTabsScreen> {

  late int _selectedPageIndex;


  void callback() {
    print("callback");
  }

  final List<Map<String, Object>> _pages = [
    {'page': home(), 'title': 'Home'},
    {'page': package(), 'title': 'PACKAGE'},
    {'page': memberspage(), 'title': 'MEMBERS'},
    {'page': wallet(), 'title': 'USERPIN'},
    {'page': report(), 'title': 'ACCOUNT'},
  ];

  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  Map<String, Object> get currentPage {
    return _pages[_selectedPageIndex];
  }
  @override
  void initState() {
    super.initState();
    _selectedPageIndex = widget.initialPageIndex;
  }
  @override
  Widget build(BuildContext context) {
    GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      backgroundColor: marketbg,
      // appBar: AppBarStyle1(title: currentPage['title'] as String),

      body: currentPage['page'] as Widget,
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.white, // Change the shadow color as needed
                blurRadius: 5.0, // Adjust the blur radius
                spreadRadius: 5, // Adjust the spread radius
                offset: Offset(0, 3), // Adjust the shadow offset
              ),
            ],
          ),
          // Adjust the radius as needed
          child: BottomNavigationBar(
            unselectedItemColor: Colors.white,
            selectedItemColor: yellow,
            backgroundColor: bottomtabbg,
            onTap: _selectPage,
            currentIndex: _selectedPageIndex,
            showUnselectedLabels: true,
            type: BottomNavigationBarType.fixed,
            items: [
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SvgPicture.asset(
                    "assets/svg/homenew.svg",
                    height: 20,
                    color: (_selectedPageIndex == 0) ? yellow : null,
                  ),
                ),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SvgPicture.asset(
                    "assets/svg/packagenew.svg",
                    height: 20,
                    color: (_selectedPageIndex == 1) ? yellow : null,
                  ),
                ),
                label: 'Package ',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SvgPicture.asset(
                    "assets/svg/membernew.svg",
                    height: 20,
                    color: (_selectedPageIndex == 2) ? yellow : null,
                  ),
                ),
                label: 'Network',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SvgPicture.asset(
                    "assets/svg/walletnew.svg",
                    height: 20,
                    color: (_selectedPageIndex == 3) ? yellow : null,
                  ),
                ),
                label: 'Wallet',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SvgPicture.asset(
                    "assets/svg/report.svg",
                    height: 20,
                    color: (_selectedPageIndex == 4) ? yellow : null,
                  ),
                ),
                label: 'Income',
              ),
            ],
          ),
        ),
      ),
    );
  }
}