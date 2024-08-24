import 'package:consultation_app/models/employee.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmployeeService {
  final String _apiUrl = 'http://consultationapp.runasp.net/api/employee';

  Future<Employee> getEmployeeData(int employeeId) async {
    final response = await http.get(Uri.parse('$_apiUrl/$employeeId'));

    if (response.statusCode == 200) {
      final dynamic body = json.decode(response.body);
      return Employee.fromJson(body);
    } else {
      throw Exception('Failed to load employee data');
    }
  }

  Future<List<Employee>> getEmployees(int categoryId) async {
    final response = await http.get(Uri.parse('$_apiUrl/category/$categoryId'));
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((employee) => Employee.fromJson(employee)).toList();
    } else {
      throw Exception('Failed to load employees');
    }
  }

  Future<List<Employee>> getActiveEmployees(int categoryId) async {
    final response =
        await http.get(Uri.parse('$_apiUrl/category/active/$categoryId'));
    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((employee) => Employee.fromJson(employee)).toList();
    } else {
      throw Exception('Failed to load active employees');
    }
  }

  Future<double> getEmployeeRating(int employeeId) async {
    final response = await http.get(Uri.parse('$_apiUrl/rating/$employeeId'));
    if (response.statusCode == 200) {
      final body = jsonDecode(response.body);
      return body.toDouble();
    } else {
      throw Exception('Failed to load average rating');
    }
  }

  Future<void> addEmployee(Employee employee) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toAddJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to add a new employee');
    }
  }

  Future<void> updateEmployee(Employee employee) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/${employee.id}'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(employee.toUpdateJson()),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update the employee');
    }
  }
}
