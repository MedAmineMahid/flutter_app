import 'package:flutter/material.dart';
import 'settingsPage.dart';
import 'profilePage.dart';

class TrackerPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('WellTrack'),
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Health Metrics',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
            ),
            SizedBox(height: 16),
            HealthMetricCard(
              title: 'Steps',
              value: 'Today\'s steps: 8,000',
            ),
            HealthMetricCard(
              title: 'Sleep',
              value: 'Last night: 7 hrs',
            ),
            HealthMetricCard(
              title: 'Water Intake',
              value: 'Today: 2.5L',
            ),
            HealthMetricCard(
              title: 'Exercise',
              value: 'This week: 3 hrs',
            ),
            HealthMetricCard(
              title: 'Nutrition',
              value: 'Calories today: 1800',
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.add),
      ),
      // Remove the BottomNavigationBar here
    );
  }
}

class HealthMetricCard extends StatelessWidget {
  final String title;
  final String value;

  HealthMetricCard({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[850],
      margin: EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(title, style: TextStyle(color: Colors.white)),
        subtitle: Text(value, style: TextStyle(color: Colors.grey)),
      ),
    );
  }
}
