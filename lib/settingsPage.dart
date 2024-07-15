import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Settings',
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.black, 
      ),
      
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            SettingsSection(
              title: 'Tracker Preferences',
              children: [
                SettingsSwitch(title: 'Enable Step Tracker'),
                SettingsSwitch(title: 'Enable Sleep Tracker'),
              ],
            ),
            SettingsSection(
              title: 'Goals',
              children: [
                SettingsDropdown(title: 'Daily Step Goal', value: '138'),
                SettingsDropdown(title: 'Daily Sleep Goal (hours)', value: '138'),
              ],
            ),
            SettingsSection(
              title: 'Account Settings',
              children: [
                SettingsButton(title: 'Change Password', buttonText: 'Change', buttonColor: Colors.blue),
                SettingsButton(title: 'Delete Account', buttonText: 'Delete', buttonColor: Colors.red),
              ],
            ),
            SettingsSection(
              title: 'Sync Options',
              children: [
                SettingsSwitch(title: 'Sync with Wearables'),
                SettingsSwitch(title: 'Sync with Other Apps'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        color: Colors.grey[850], 
        child: Column(
          children: [
            ListTile(
              title: Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white, 
                ),
              ),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class SettingsSwitch extends StatelessWidget {
  final String title;

  SettingsSwitch({required this.title});

  @override
  Widget build(BuildContext context) {
    return SwitchListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white), 
      ),
      value: true, 
      onChanged: (bool value) {
       
      },
      activeColor: Colors.blue, 
      inactiveThumbColor: Colors.grey, 
      inactiveTrackColor: Colors.grey[700], 
    );
  }
}

class SettingsDropdown extends StatelessWidget {
  final String title;
  final String value;

  SettingsDropdown({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white), 
      ),
      trailing: DropdownButton<String>(
        value: value,
        dropdownColor: Colors.grey[850], 
        onChanged: (String? newValue) {
          
        },
        items: <String>['138', '200', '300']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: TextStyle(color: Colors.white), 
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SettingsButton extends StatelessWidget {
  final String title;
  final String buttonText;
  final Color buttonColor;

  SettingsButton({required this.title, required this.buttonText, required this.buttonColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        title,
        style: TextStyle(color: Colors.white), 
      ),
      trailing: ElevatedButton(
        onPressed: () {
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
        ),
        child: Text(buttonText),
      ),
    );
  }
}
