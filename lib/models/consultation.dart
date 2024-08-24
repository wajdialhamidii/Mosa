class Consultation {
  final int? id;
  final String? title;
  final DateTime? startTime;
  final DateTime? endTime;
  final int? status;
  final int? clientId;
  final int? employeeId;

  Consultation({
    this.id,
    this.title,
    this.startTime,
    this.endTime,
    this.status,
    this.clientId,
    this.employeeId,
  });

  factory Consultation.create({
    required DateTime startTime,
    required String title,
    required int clientId,
    required int employeeId,
  }) {
    return Consultation(
      startTime: startTime,
      title: title,
      clientId: clientId,
      employeeId: employeeId,
    );
  }

  factory Consultation.fromJson(Map<String, dynamic> jsonData) {
    return Consultation(
      id: jsonData['id'],
      status: jsonData['status'],
      title: jsonData['title'],
      startTime: DateTime.parse(jsonData['startTime'] as String),
      endTime: jsonData['endTime'] != null
          ? DateTime.parse(jsonData['endTime'] as String)
          : null,
      clientId: jsonData['clientId'],
      employeeId: jsonData['employeeId'],
    );
  }

  factory Consultation.update({
    required int id,
    required DateTime endTime,
    required int status,
  }) {
    return Consultation(
      id: id,
      endTime: endTime,
      status: status,
    );
  }

  Map<String, dynamic> toJsonForCreate() => {
        'startTime': startTime!.toIso8601String(),
        'title': title,
        'clientId': clientId,
        'employeeId': employeeId,
      };

  Map<String, dynamic> toJsonForUpdate() => {
        'endTime': endTime!.toIso8601String(),
        'status': status,
      };
}

// enum ConsultationStatus {
//   ongoing,
//   completed,
// }
