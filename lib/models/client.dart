class Client {
  final int? id;
  final String name;
  final String? companyName;
  final String email;
  final String password;

  Client({
    this.id,
    required this.name,
    this.companyName,
    required this.email,
    required this.password,
  });

  factory Client.fromJson(Map<String, dynamic> jsonData) {
    return Client(
      id: jsonData['id'],
      name: jsonData['name'],
      companyName: jsonData['companyName'],
      email: jsonData['email'],
      password: jsonData['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'companyName': companyName,
      'email': email,
      'password': password,
    };
  }

  Map<String, dynamic> toJsonForUpdate() {
    return {
      'id': id,
      'name': name,
      'companyName': companyName,
      'email': email,
      'password': password,
    };
  }
}
