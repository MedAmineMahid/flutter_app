import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';

class ApiService {
    static const String _nutritionixBaseUrl = 'https://trackapi.nutritionix.com/v2';
 static const String _appId = '53e2331c'; // Replace with your Nutritionix App ID
  static const String _appKey = 'c822a47e0b6e4400e87780857b11ab3c';
  static const String _baseUrl = 'http://localhost:8080/api';
  static const storage = FlutterSecureStorage();

  // Login user and store the token
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

  // Retrieve headers with token
  static Future<Map<String, String>> getHeaders() async {
    final token = await storage.read(key: 'token');
    if (token == null || token.isEmpty) {
      throw Exception('No valid token found. Please log in.');
    }
    return {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token',
    };
  }

// Register a new user
static Future<http.Response> registerUser(String email, String password, String name, int age, String gender, String goal) async {
  final url = Uri.parse('$_baseUrl/auth/register');
  try {
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{  // dynamic allows int type for age
        'username': email,
        'password': password,
        'name': name,
        'age': age,
        'gender': gender,
        'goal': goal,
      }),
    );

    if (response.statusCode == 201) {
      if (response.headers['content-type']?.contains('application/json') ?? false) {
        final data = jsonDecode(response.body);
        await storage.write(key: 'userId', value: data['userId']);  // Store userId in secure storage
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


  // Add a new activity
  static Future<http.Response> addActivity(Map<String, dynamic> activityData) async {
    final url = Uri.parse('$_baseUrl/activities');
    try {
      final response = await http.post(
        url,
        headers: await getHeaders(),
        body: jsonEncode(activityData),
      );
      if (response.statusCode == 200) {
        print('Activity added successfully');
      } else {
        print('Failed to add activity: ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error adding activity: $e');
      rethrow;
    }
  }

  // Fetch the signed-in user's ID
  static Future<String?> fetchSignedInUserId() async {
    final url = Uri.parse('$_baseUrl/activities/user');
    try {
      final response = await http.get(url, headers: await getHeaders());
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        return response.body; // Adjust this if needed, e.g., jsonDecode(response.body)['userId'];
      } else {
        print('Failed to fetch signed-in user ID: ${response.body}');
      }
    } catch (e) {
      print('Error fetching signed-in user ID: $e');
    }
    return null;
  }
  static Future<http.Response> searchFood(String query) async {
    final url = Uri.parse('$_nutritionixBaseUrl/search/instant?query=$query');
    try {
      final response = await http.get(
        url,
        headers: {
          'x-app-id': _appId,
          'x-app-key': _appKey,
        },
      );
      return response;
    } catch (e) {
      print('Error searching food: $e');
      rethrow;
    }
  }

  // Get food calories (natural search)
  static Future<http.Response> getFoodCalories(String foodName) async {
    final url = Uri.parse('$_nutritionixBaseUrl/natural/nutrients');
    try {
      final response = await http.post(
        url,
        headers: {
          'x-app-id': _appId,
          'x-app-key': _appKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode(<String, String>{'query': foodName}),
      );
      return response;
    } catch (e) {
      print('Error getting food calories: $e');
      rethrow;
    }
  }  // Add meal (save meal)
  static Future<http.Response> saveMeal(Map<String, dynamic> mealData) async {
    final url = Uri.parse('$_baseUrl/meals');
    try {
      final response = await http.post(
        url,
        headers: await getHeaders(), 
        body: jsonEncode(mealData),
      );
      if (response.statusCode == 201) {
        print('Meal saved successfully');
      } else if (response.statusCode == 401) {
        print('Unauthorized. Please log in again.');
      } else {
        print('Failed to save meal: ${response.statusCode}, ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error saving meal: $e');
      rethrow;
    }
  }

  // Fetch the signed-in user's data
  static Future<http.Response> fetchUserData(String userId) async {
    final url = Uri.parse('$_baseUrl/user/$userId');
    try {
      final response = await http.get(url, headers: await getHeaders());
      return response;
    } catch (e) {
      print('Error fetching user data: $e');
      rethrow;
    }
  }

  // Fetch the signed-in user's activities
  static Future<List<Map<String, dynamic>>> fetchUserActivities(String userId) async {
    final url = Uri.parse('$_baseUrl/activities/user/$userId/activities');
    try {
      final response = await http.get(url, headers: await getHeaders());
      if (response.statusCode == 200) {
        final List<dynamic> activities = jsonDecode(response.body);
        return activities.map((activity) => Map<String, dynamic>.from(activity)).toList();
      } else {
        print('Failed to fetch user activities: ${response.body}');
        return [];
      }
    } catch (e) {
      print('Error fetching user activities: $e');
      return [];
    }
  }
}
