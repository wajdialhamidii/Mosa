import 'dart:convert';

import 'package:consultation_app/models/consultation.dart';
import 'package:http/http.dart' as http;

class ConsultationService {
  final String _apiUrl = 'http://consultationapp.runasp.net/api/consultation';

  Future<List<Consultation>> getAllClientConsultations(int clientId) async {
    final response = await http.get(Uri.parse('$_apiUrl/client/$clientId'));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body
          .map((consultation) => Consultation.fromJson(consultation))
          .toList();
    } else {
      throw Exception('Failed to load client consultations');
    }
  }

  Future<List<Consultation>> getAllEmployeeConsultations(int employeeId) async {
    final response = await http.get(Uri.parse('$_apiUrl/employee/$employeeId'));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body
          .map((consultation) => Consultation.fromJson(consultation))
          .toList();
    } else {
      throw Exception('Failed to load employee consultations');
    }
  }

  Future<void> addConsultation(Consultation consultation) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(consultation.toJsonForCreate()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add a new consultation.');
    }
  }

  Future<void> updateConsultation(Consultation consultation) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/${consultation.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(consultation.toJsonForUpdate()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update the consultation.');
    }
  }

  Future<void> deleteConsultation(int consultationId) async {
    final response = await http.delete(Uri.parse('$_apiUrl/$consultationId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete consultation.');
    }
  }
}
