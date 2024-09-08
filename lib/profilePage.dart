import 'package:flutter/material.dart';
import 'api_service.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Map<String, dynamic>? userData;
  String? userId;
  String? selectedActivity;
  DateTime? selectedDate;
  List<Map<String, dynamic>> userActivities = [];
  final List<String> activities = [
    'Running', 'Walking', 'Jogging', 'Gym', 'Yoga', 'HIIT', 'CrossFit', 'Cycling'
  ];

  @override
  void initState() {
    super.initState();
    _fetchSignedInUserId();
  }

  Future<void> _fetchSignedInUserId() async {
    try {
      userId = await ApiService.fetchSignedInUserId();
      if (userId != null) {
        await _fetchUserData();
        await _fetchUserActivities();
        print('Got the signed-in user ID');
      } else {
        print('Failed to get the signed-in user ID');
      }
    } catch (e) {
      print('Error fetching signed-in user ID: $e');
    }
  }

  Future<void> _fetchUserData() async {
    if (userId != null) {
      try {
        final response = await ApiService.fetchUserData(userId!);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = jsonDecode(response.body);
          setState(() {
            userData = {
              'userId': data['userId'],
              'username': data['username'],
              'age': data['age'],
              'gender': data['gender'],
              'firstName': data['firstName'],
              'lastName': data['lastName'],
              'healthGoals': data['healthGoals'],
              'goals': data['goals'],
            };
          });
        } else {
          print('Failed to load user data: ${response.body}');
        }
      } catch (e) {
        print('Error fetching user data: $e');
      }
    } else {
      print('User ID is null');
    }
  }

  Future<void> _fetchUserActivities() async {
    if (userId != null) {
      try {
        final List<Map<String, dynamic>> activities = await ApiService.fetchUserActivities(userId!);
        setState(() {
          userActivities = activities;
        });
      } catch (e) {
        print('Error fetching user activities: $e');
      }
    } else {
      print('User ID is null');
    }
  }

  Future<void> _createActivity(String title, String description, String duration, DateTime? date) async {
    if (userId == null) {
      print('User ID is null, cannot create activity');
      return;
    }

    final activityData = {
      'title': title,
      'description': description,
      'duration': duration,
      'time': date != null ? DateFormat('yyyy-MM-dd').format(date) : null,
      'userId': userId,
    };

    try {
      final response = await ApiService.addActivity(activityData);
      if (response.statusCode == 201) {
        print('Activity created successfully');
        await _fetchUserActivities(); // Refresh activities after creating a new one
      } else {
        print('Failed to create activity: ${response.body}');
      }
    } catch (e) {
      print('Error creating activity: $e');
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
              if (selectedActivity != null)
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
    return SafeArea(
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
                      RecordWidget(icon: Icons.directions_run, label: 'Marathoner'),
                      RecordWidget(icon: Icons.star, label: 'Champion'),
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
                        'My Activities',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      TextButton(
                        onPressed: _showCreateActivityDialog,
                        child: Text(
                          'Add New',
                          style: TextStyle(color: Colors.blue, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                userActivities.isEmpty
                    ? Center(
                        child: Text(
                          'No activities found.',
                          style: TextStyle(color: Colors.white),
                        ),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: userActivities.length,
                        itemBuilder: (context, index) {
                          final activity = userActivities[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey[850],
                                borderRadius: BorderRadius.circular(12.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 6.0,
                                    spreadRadius: 1.0,
                                    offset: Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      activity['title'] ?? 'No title',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.timer, color: Colors.grey[400], size: 18),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Duration: ${activity['duration'] ?? 'No duration'} minutes',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Icon(Icons.local_fire_department, color: Colors.grey[400], size: 18),
                                        SizedBox(width: 4),
                                        Expanded(
                                          child: Text(
                                            'Calories Burned: ${activity['caloriesBurned'] ?? 'N/A'}',
                                            style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class RecordWidget extends StatelessWidget {
  final IconData icon;
  final String label;

  const RecordWidget({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        Text(
          label,
          style: TextStyle(color: Colors.white),
        ),
      ],
    );
  }
}
