import 'package:flutter/material.dart';
import 'package:master_journey/screens/members/widgets/childone.dart';
import '../../../../resources/color.dart';

class Mobileview extends StatefulWidget {
  @override
  State<Mobileview> createState() => _MobileviewState();
}

class _MobileviewState extends State<Mobileview> {
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Initialize any required data here if necessary
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: marketbg,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            // Search bar implementation
            Container(
              height: 40,
              child: TextField(
                controller: searchController,
                onChanged: (value) {
                  // Trigger rebuild to pass the search query to Childone
                  setState(() {});
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
            // Pass the search query to the Childone widget
            Expanded(
              child: Childone(
                searchQuery: searchController.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}