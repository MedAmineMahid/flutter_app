import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:convert'; // Import this to use jsonDecode

import 'package:flutter_tested/api_service.dart';
class ActivitiesPage extends StatefulWidget {
  @override
  _ActivitiesPageState createState() => _ActivitiesPageState();
}

class _ActivitiesPageState extends State<ActivitiesPage> {
  List<dynamic> activities = [];

  @override
  void initState() {
    super.initState();
    _fetchActivities();
  }

  void _fetchActivities() async {
    final response = await ApiService.fetchUserActivities('user_id');
    setState(() {
      activities = jsonDecode(response.body);
    });
  }

  void _addActivity() async {
    // Logic to show a form to add a new activity
    Map<String, dynamic> newActivity = {
      'name': 'Running',
      'duration': 30, // Example data
    };
    await ApiService.addActivity(newActivity);
    _fetchActivities(); // Refresh the activities list
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Activities'),
      ),
      body: ListView.builder(
        itemCount: activities.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(activities[index]['name']),
            subtitle: Text('Duration: ${activities[index]['duration']} mins'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addActivity,
        child: Icon(Icons.add),
      ),
    );
  }
}
