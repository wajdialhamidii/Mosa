import 'package:consultation_app/models/super_admin.dart';
import 'package:consultation_app/services/admin_service.dart';
import 'package:flutter/material.dart';

class AdminViewModel extends ChangeNotifier {
  final AdminService _adminService = AdminService();

  SuperAdmin? _admin;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  SuperAdmin? get getAdmin => _admin;

  Future<void> getAdminData(int adminId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _admin = await _adminService.getAdminData(adminId);
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAdmin(SuperAdmin admin) async {
    try {
      await _adminService.updateAdmin(admin);
    } catch (e) {
      throw Exception(e);
    }
  }
}
