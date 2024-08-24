import 'package:consultation_app/services/auth_service.dart';
import 'package:consultation_app/utils/constants.dart';
import 'package:consultation_app/utils/message_dialog_util.dart';
import 'package:consultation_app/utils/snackbar_util.dart';
import 'package:consultation_app/views/client/client_consultations_screen.dart';
import 'package:consultation_app/views/employee/employee_consultations_screen.dart';
import 'package:consultation_app/views/login_screen.dart';
import 'package:consultation_app/views/super_admin/admin_categories_screen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService();

  Future<void> login(
      BuildContext context, String email, String password) async {
    try {
      final loginResponse = await _authService.login(email, password);

      await _authService.saveUserData(loginResponse);

      _navigateBasedOnRole(context, loginResponse.role);
      SnackbarUtil.showSnackbar(
          context, 'Welcome back, ${loginResponse.user.name}!', kMainColor);
    } catch (e) {
      if (Navigator.canPop(context)) {
        Navigator.pop(context);
      }
      MessageDialogUtil.showErrorMessageDialog(context, e.toString());
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        (route) => false);

    SnackbarUtil.showSnackbar(context, 'Come back soon.', kMainColor);
  }

  Future<void> checkLoginStatus(BuildContext context) async {
    String? role = await _authService.getUserRole();
    _navigateBasedOnRole(context, role);
  }

  void _navigateBasedOnRole(BuildContext context, String? role) {
    if (role != null) {
      if (role == 'SuperAdmin') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminCategoriesScreen()),
            (Route<dynamic> route) => false);
      } else if (role == 'Employee') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const EmployeeConsultationScreen()),
            (Route<dynamic> route) => false);
      } else if (role == 'Client') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const ClientConsultationScreen()),
            (Route<dynamic> route) => false);
      }
    } else {
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (Route<dynamic> route) => false);
    }
  }
}
