import 'package:flutter/material.dart';
import 'dart:convert';
import 'api_service.dart';

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
    if (response.statusCode == 200) {
      setState(() {
        activities = jsonDecode(response.body);
      });
    } else {
      print('Failed to load activities: ${response.body}');
    }
  }

  void _addActivity() async {
    Map<String, dynamic> newActivity = {
      'name': 'Running',
      'duration': 30, // Example data
    };
    final response = await ApiService.addActivity(newActivity);
    if (response.statusCode == 201) {
      _fetchActivities(); // Refresh the activities list
    } else {
      print('Failed to add activity: ${response.body}');
    }
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
