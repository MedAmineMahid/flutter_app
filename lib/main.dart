import 'package:flutter/material.dart';
import 'profilePage.dart'; 
import 'trackerPage.dart';
import 'login.dart'; 
import 'settingsPage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      
      //home: ProfilePage(),
      home: LoginPage(),
      //home: TrackerPage(),
      debugShowCheckedModeBanner: false, 
    );
  }
}
