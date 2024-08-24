class SuperAdmin {
  final int id;
  final String name;
  final String email;
  final String password;

  SuperAdmin({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  factory SuperAdmin.fromJson(Map<String, dynamic> jsonData) {
    return SuperAdmin(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
      password: jsonData['password'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
