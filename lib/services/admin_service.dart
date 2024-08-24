import 'dart:convert';
import 'package:consultation_app/models/super_admin.dart';
import 'package:http/http.dart' as http;

class AdminService {
  final String _apiUrl = 'http://consultationapp.runasp.net/api/superadmin';

  Future<SuperAdmin> getAdminData(int adminId) async {
    final response = await http.get(Uri.parse('$_apiUrl/$adminId'));

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      return SuperAdmin.fromJson(body);
    } else {
      throw Exception('Failed to load admin data: ${response.reasonPhrase}');
    }
  }

  Future<void> updateAdmin(SuperAdmin admin) async {
    final response = await http.put(Uri.parse('$_apiUrl/${admin.id}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(admin.toJson()));

    if (response.statusCode != 200) {
      throw Exception('Failed to update account: ${response.reasonPhrase}');
    }
  }
}
