import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:8080/api/auth';

  static Future<http.Response> loginUser(String email, String password) async {
    final url = Uri.parse('$_baseUrl/login');
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
      if (response.statusCode != 200) {
        print('Failed to login: ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error during login: $e');
      rethrow;
    }
  }

  static Future<http.Response> registerUser(String email, String password, String name, String fullName) async {
    final url = Uri.parse('$_baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': email,
          'password': password,
          'name': name,
          'firstName': fullName,
        }),
      );
      if (response.statusCode != 201) {
        print('Failed to register: ${response.body}');
      }
      return response;
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }
}
