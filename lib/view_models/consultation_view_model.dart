import 'package:consultation_app/models/consultation.dart';
import 'package:consultation_app/services/consultation_service.dart';
import 'package:flutter/cupertino.dart';

class ConsultationViewModel extends ChangeNotifier {
  final ConsultationService _consultationService = ConsultationService();

  List<Consultation> _consultations = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Consultation> get getConsultations => _consultations;

  Future<void> fetchClientConsultations(int clientId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _consultations =
          await _consultationService.getAllClientConsultations(clientId);

      //sorting by status then by time
      _consultations.sort((a, b) {
        int statusComparison = a.status!.compareTo(b.status!);
        if (statusComparison != 0) {
          return statusComparison;
        }
        return b.startTime!.compareTo(a.startTime!);
      });
    } catch (e) {
      print('Error fetching consultations: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchEmployeeConsultations(int employeeId) async {
    _isLoading = true;
    notifyListeners();
    try {
      _consultations =
          await _consultationService.getAllEmployeeConsultations(employeeId);

      //sorting by status then by time
      _consultations.sort((a, b) {
        int statusComparison = a.status!.compareTo(b.status!);
        if (statusComparison != 0) {
          return statusComparison;
        }
        return b.startTime!.compareTo(a.startTime!);
      });
    } catch (e) {
      throw Exception(e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addConsultation(Consultation consultation) async {
    try {
      await _consultationService.addConsultation(consultation);
      await fetchClientConsultations(consultation.clientId!);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateConsultation(
      Consultation consultation, int clientId) async {
    try {
      await _consultationService.updateConsultation(consultation);
      await fetchClientConsultations(clientId);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> deleteConsultation(int consultationId, int clientId) async {
    try {
      await _consultationService.deleteConsultation(consultationId);
      await fetchClientConsultations(clientId);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }
}
