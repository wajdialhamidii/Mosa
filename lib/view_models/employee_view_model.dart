import 'package:consultation_app/models/employee.dart';
import 'package:consultation_app/services/employee_service.dart';
import 'package:flutter/cupertino.dart';

class EmployeeViewModel extends ChangeNotifier {
  final EmployeeService _employeeService = EmployeeService();
  List<Employee> _employees = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Employee> get getEmployees => _employees;

  Employee? _employee;
  Employee? get getEmployee => _employee;

  Future<void> getEmployeeData(int employeeId) async {
    _isLoading = true;
    try {
      _employee = await _employeeService.getEmployeeData(employeeId);
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEmployees(int categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _employees = await _employeeService.getEmployees(categoryId);
    } catch (e) {
      throw Exception('Failed to load employees:$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<double> getEmployeeRating(int employeeId) async {
    try {
      return await _employeeService.getEmployeeRating(employeeId);
    } catch (e) {
      return 1;
    }
  }

  Future<void> fetchActiveEmployees(int categoryId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _employees = await _employeeService.getActiveEmployees(categoryId);
    } catch (e) {
      throw Exception('Failed to load employees:$e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addEmployee(Employee employee, int categoryId) async {
    try {
      await _employeeService.addEmployee(employee);
      await fetchEmployees(categoryId);
    } catch (e) {
      throw Exception('Failed to add a new employee.');
    }
  }

  Future<void> updateEmployee(Employee employee, int categoryId) async {
    try {
      await _employeeService.updateEmployee(employee);
      await fetchEmployees(categoryId);
    } catch (e) {
      throw Exception('Failed to update the employee: $e');
    }
  }
}
