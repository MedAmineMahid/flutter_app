import 'package:flutter/material.dart';
import 'package:flutter_tested/exercise.dart';
import 'login.dart';
import 'nutrition.dart';
import 'profilePage.dart';
import 'settingsPage.dart';
import 'trackerPage.dart';

void main() {
  runApp(WellTrackApp());
}

class WellTrackApp extends StatefulWidget {
  final bool isLoggedIn;

  WellTrackApp({this.isLoggedIn = false}); // Default to false if not provided

  @override
  _WellTrackAppState createState() => _WellTrackAppState();
}

class _WellTrackAppState extends State<WellTrackApp> {
  int _selectedIndex = 0;
  bool _isLoggedIn;

  _WellTrackAppState() : _isLoggedIn = false;

  final List<Widget> _pages = [
    ProfilePage(),
    TrackerPageContent(),
    SettingsPage(),
    NutritionPage(),
    ExercisePage(), // Add the Exercise page
  ];

  @override
  void initState() {
    super.initState();
    _isLoggedIn = widget.isLoggedIn; // Set the login status from the passed value
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: Colors.black,
        primaryColor: Colors.blue,
      ),
      home: _isLoggedIn
          ? Scaffold(
              body: _pages[_selectedIndex],
              bottomNavigationBar: BottomNavigationBar(
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    label: 'Profile',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.show_chart),
                    label: 'Tracking',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.settings),
                    label: 'Settings',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.restaurant),
                    label: 'Nutrition',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.fitness_center),
                    label: 'Exercise', // Add Exercise category
                  ),
                ],
                currentIndex: _selectedIndex,
                selectedItemColor: Colors.blue,
                unselectedItemColor: Colors.white,
                backgroundColor: Colors.black,
                onTap: _onItemTapped,
              ),
            )
          : LoginPage(), // Show login page if the user is not logged in
    );
  }
}
