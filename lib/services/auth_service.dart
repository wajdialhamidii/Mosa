import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/login_response.dart';
import 'package:http/http.dart' as http;

class AuthService {
  final String _apiUrl = 'http://consultationapp.runasp.net/api';

  Future<LoginResponse> login(String email, String password) async {
    var response = await http.post(
      Uri.parse('$_apiUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return LoginResponse.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Incorrect email or password');
    } else if (response.statusCode == 500) {
      throw Exception('Server error. Please try again later.');
    } else {
      throw Exception('Failed to login');
    }
  }

  Future<void> saveUserData(LoginResponse loginResponse) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('role', loginResponse.role);
    await prefs.setInt('userId', loginResponse.user.id);
    await prefs.setString('userName', loginResponse.user.name);
  }

  Future<String?> getUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('role');
  }

  Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('userId');
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userName');
  }
}
