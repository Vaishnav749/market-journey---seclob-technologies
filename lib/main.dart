import 'package:flutter/material.dart';
import 'package:master_journey/authentication_page/login.dart';
import 'package:master_journey/authentication_page/splash.dart';
import 'package:master_journey/screens/home/home_page.dart';

import 'authentication_page/LandingPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}