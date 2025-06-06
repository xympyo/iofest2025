import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android emulator, change to your LAN IP if using a real device
  static const String baseUrl = 'http://10.0.2.2:8000/api/v1';

  // Login
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    final url = Uri.parse('$baseUrl/login');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'email': email,
          'password': password,
        },
      );
      final data = json.decode(response.body);
      if (response.statusCode == 200 && data['token'] != null) {
        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        return {'success': false, 'message': data['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Register
  static Future<Map<String, dynamic>> register(
      String username, String email, String password, String confirmPassword) async {
    final url = Uri.parse('$baseUrl/register');
    try {
      final response = await http.post(
        url,
        headers: {
          'Accept': 'application/json',
        },
        body: {
          'name': username,
          'username': username,
          'email': email,
          'password': password,
          'password_confirmation': confirmPassword,
        },
      );
      final data = json.decode(response.body);
      if (response.statusCode == 201 && data['token'] != null) {
        return {'success': true, 'token': data['token'], 'user': data['user']};
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }
}
