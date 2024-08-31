import 'package:flutter/material.dart';
import 'api_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';  // For formatting date

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  String? userId;
  String? selectedActivity;
  DateTime? selectedDate;
  final List<String> activities = [
    'Running',
    'Walking',
    'Jogging',
    'Gym',
    'Yoga',
    'HIIT',
    'CrossFit',
    'Cycling'
  ];

  @override
  void initState() {
    super.initState();
    _fetchSignedInUserId();
  }

  void _fetchSignedInUserId() async {
    userId = await ApiService.fetchSignedInUserId();
    if (userId != null) {
      _fetchUserData();
      print('Got the signed-in user ID');
    } else {
      print('Failed to get the signed-in user ID');
    }
  }

  void _fetchUserData() async {
    if (userId != null) {
      final response = await ApiService.fetchUserData(userId!);
      if (response.statusCode == 200) {
        setState(() {
          userData = jsonDecode(response.body);
        });
      } else {
        print('Failed to load user data');
      }
    } else {
      print('User ID is null');
    }
  }

  void _createActivity(String title, String description, String duration, DateTime? date) async {
    if (userId == null) {
      print('User ID is null, cannot create activity');
      return;
    }

    final activityData = {
      'title': title,
      'description': description,
      'duration': duration,
      'date': date != null ? DateFormat('yyyy-MM-dd').format(date) : null,
      'userId': userId,
    };

    print('Activity Data: $activityData'); // Debug print

    final response = await ApiService.addActivity(activityData);

    if (response.statusCode == 201) {
      print('Activity created successfully');
      _fetchUserData();
    } else {
      print('Failed to create activity: ${response.body}');
    }
  }

  void _showCreateActivityDialog() {
  final descriptionController = TextEditingController();
  final durationController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Create New Activity'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selectedActivity != null) // Check if an activity is selected
              Text(
                'Title: $selectedActivity',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(labelText: 'Description'),
            ),
            TextField(
              controller: durationController,
              decoration: InputDecoration(labelText: 'Duration'),
              keyboardType: TextInputType.number,
            ),
            DropdownButton<String>(
              value: selectedActivity,
              hint: Text('Select Activity'),
              items: activities.map((activity) {
                return DropdownMenuItem<String>(
                  value: activity,
                  child: Text(activity),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedActivity = value;
                });
              },
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                final DateTime? picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (picked != null && picked != selectedDate)
                  setState(() {
                    selectedDate = picked;
                  });
              },
              child: Text(
                selectedDate == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(selectedDate!),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (selectedActivity != null) {
                _createActivity(
                  selectedActivity!,
                  descriptionController.text,
                  durationController.text,
                  selectedDate,
                );
                Navigator.of(context).pop();
              } else {
                print('No activity selected');
              }
            },
            child: Text('Create'),
          ),
        ],
      );
    },
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('images/pexels-willpicturethis-1954524.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        left: 200,
                        bottom: 10,
                        child: CircleAvatar(
                          radius: 50,
                          backgroundImage: AssetImage("images/pexels-anush-1229356.jpg"),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Fitness Profile',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Joined in 2020',
                          style: TextStyle(
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  userData == null
                      ? Center(child: CircularProgressIndicator())
                      : Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Name: ${userData!['firstName'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Email: ${userData!['username'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Age: ${userData!['age'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Gender: ${userData!['gender'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.white),
                              ),
                              Text(
                                'Health Goals: ${userData!['healthGoals'] ?? 'N/A'}',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Personal Records',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to personal records screen
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        RecordWidget(icon: Icons.wb_sunny, label: 'Early Riser'),
                        RecordWidget(icon: Icons.directions_run, label: 'Active'),
                        RecordWidget(icon: Icons.local_fire_department, label: 'Consistent Runner'),
                        RecordWidget(icon: Icons.opacity, label: 'Refresh!'),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Latest Updates',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        TextButton(
                          onPressed: () {
                            // Navigate to latest updates screen
                          },
                          child: Text(
                            'See all',
                            style: TextStyle(color: Colors.blue, fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),
                  Column(
                    children: [
                      UpdateWidget(
                        icon: Icons.self_improvement,
                        activity: 'Morning Yoga Session',
                        date: '10/08/2023',
                      ),
                      UpdateWidget(
                        icon: Icons.sports_tennis,
                        activity: 'Tennis Match, 45 mins',
                        date: '08/08/2023',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: FloatingActionButton(
                onPressed: _showCreateActivityDialog,
                backgroundColor: Colors.blue,
                child: Icon(Icons.add, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: 'Trackers',
          ),
        ],
        currentIndex: 0,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.white,
        backgroundColor: Colors.black,
        onTap: (index) {
          if (index == 1) {
            // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => TrackerPage()));
            print('Navigating to Trackers Page'); // Placeholder for navigation
          }
        },
      ),
    );
  }
}

class RecordWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  RecordWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.blue,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(height: 5),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}

class UpdateWidget extends StatelessWidget {
  final IconData icon;
  final String activity;
  final String date;

  UpdateWidget({required this.icon, required this.activity, required this.date});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(activity, style: TextStyle(color: Colors.white)),
              SizedBox(height: 5),
              Text(date, style: TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}
