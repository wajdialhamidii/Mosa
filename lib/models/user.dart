class User {
  final int id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});

  factory User.fromJson(Map<String, dynamic> jsonData) {
    return User(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
    );
  }
}
