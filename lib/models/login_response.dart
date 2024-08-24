import 'package:consultation_app/models/user.dart';

class LoginResponse {
  final String role;
  final User user;

  LoginResponse({required this.role, required this.user});

  factory LoginResponse.fromJson(Map<String, dynamic> jsonData) {
    return LoginResponse(
      role: jsonData['role'],
      user: User.fromJson(jsonData['user']),
    );
  }
}
