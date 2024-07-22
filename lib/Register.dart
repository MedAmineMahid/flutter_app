import 'package:flutter/material.dart';
import 'package:flutter_tested/Login.dart';
import 'profilePage.dart';
import 'api_service.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  void _register() async {
    final email = _emailController.text;
    final password = _passwordController.text;
    final name = _nameController.text;
    final fullName = _fullNameController.text;

    try {
      final response = await ApiService.registerUser(email, password, name, fullName);

      if (response.statusCode == 201) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      } else {
        // Handle error
        print("Failed to register: ${response.body}");
      }
    } catch (e) {
      print("Exception during registration: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Track Wellness',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  'Stay active, stay healthy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 40),
                Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _fullNameController,
                  decoration: InputDecoration(
                    labelText: 'Full Name',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _register,
                  child: Text('Join'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
