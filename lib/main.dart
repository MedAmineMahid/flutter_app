import 'package:flutter/material.dart';
import 'package:flutter_tested/login.dart';
import 'profilePage.dart';

void main() {
  runApp(WellTrackApp());
}

class WellTrackApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blue,
      ),
      home: LoginPage(),
    );
  }}