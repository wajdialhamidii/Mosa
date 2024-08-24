class Rating {
  final double ratingValue;
  final DateTime time;
  final int clientId;
  final int employeeId;

  Rating({
    required this.ratingValue,
    required this.time,
    required this.clientId,
    required this.employeeId,
  });

  Map<String, dynamic> toJson() {
    return {
      'ratingValue': ratingValue,
      'time': time.toIso8601String(),
      'clientId': clientId,
      'employeeId': employeeId,
    };
  }
}
