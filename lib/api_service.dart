import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class ApiService {
  static const String _baseUrl = 'http://localhost:8080/api';
  static const storage = FlutterSecureStorage();

  static Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/auth/login');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          final data = jsonDecode(response.body);
          await storage.write(key: 'token', value: data['token']);
        } else {
          print('Unexpected response format: ${response.body}');
        }
      } else {
        print('Failed to login: ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  static Future<Map<String, String>> _getHeaders() async {
    final token = await storage.read(key: 'token');
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

  static Future<http.Response> registerUser(String email, String password, String name, String fullName) async {
    final url = Uri.parse('$_baseUrl/auth/register');
    try {
      final response = await http.post(
        url,
        headers: await _getHeaders(),
        body: jsonEncode(<String, String>{
          'username': email,
          'password': password,
          'name': name,
          'firstName': fullName,
        }),
      );

      if (response.statusCode == 201) {
        if (response.headers['content-type']?.contains('application/json') ?? false) {
          final data = jsonDecode(response.body);
          await storage.write(key: 'userId', value: data['userId']);
        } else {
          print('Unexpected response format: ${response.body}');
        }
      } else {
        print('Failed to register: ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  static Future<http.Response> uploadMedicalRecord(String userId, File file) async {
    final url = Uri.parse('$_baseUrl/medical/upload/$userId');
    var request = http.MultipartRequest('POST', url);
    request.headers.addAll(await _getHeaders());
    request.files.add(await http.MultipartFile.fromPath('file', file.path));
    var response = await request.send();
    return http.Response.fromStream(response);
  }

  static Future<http.Response> addActivity(Map<String, dynamic> activityData) async {
    final url = Uri.parse('$_baseUrl/activities');
    final response = await http.post(
      url,
      headers: await _getHeaders(),
      body: jsonEncode(activityData),
    );
    return response;
  }

  static Future<http.Response> fetchUserActivities(String userId) async {
    final url = Uri.parse('$_baseUrl/activities/user/$userId');
    final response = await http.get(url, headers: await _getHeaders());
    return response;
  }

  static Future<String?> fetchSignedInUserId() async {
    final url = Uri.parse('$_baseUrl/activities/user');
    try {
      final response = await http.get(url, headers: await _getHeaders());
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');
      
      if (response.statusCode == 200) {
        return response.body;  // Adjust this if needed
      } else {
        print('Failed to fetch signed-in user ID: ${response.body}');
      }
    } catch (e) {
      print('Error fetching signed-in user ID: $e');
    }
    return null;
  }

  static Future<http.Response> fetchUserData(String userId) async {
    final url = Uri.parse('$_baseUrl/user/$userId');  // Adjust to the correct endpoint
    try {
      final response = await http.get(url, headers: await _getHeaders());
      if (response.statusCode == 200) {
        print('Fetched user data: ${response.body}');
      } else {
        print('Failed to fetch user data: ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }
}
