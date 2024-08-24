class Employee {
  final int? id;
  final String name;
  final String email;
  final String password;
  final bool? isActive;
  final int? categoryId;

  Employee({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    this.isActive,
    this.categoryId,
  });

  factory Employee.createEmployee({
    required String name,
    required String email,
    required String password,
    required int categoryId,
  }) {
    return Employee(
      name: name,
      email: email,
      password: password,
      categoryId: categoryId,
    );
  }

  factory Employee.updateEmployee({
    required int id,
    required String name,
    required String email,
    required String password,
    required int categoryId,
    required bool isActive,
  }) {
    return Employee(
      id: id,
      name: name,
      email: email,
      password: password,
      isActive: isActive,
      categoryId: categoryId,
    );
  }

  factory Employee.update({
    required int id,
    required String name,
    required String email,
    required String password,
  }) {
    return Employee(
      id: id,
      name: name,
      email: email,
      password: password,
    );
  }

  factory Employee.fromJson(Map<String, dynamic> jsonData) {
    return Employee(
      id: jsonData['id'],
      name: jsonData['name'],
      email: jsonData['email'],
      password: jsonData['password'],
      isActive: jsonData['isActive'],
      categoryId: jsonData['categoryId'],
    );
  }

  Map<String, dynamic> toAddJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'categoryId': categoryId,
    };
  }

  Map<String, dynamic> toUpdateEmployeeJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'categoryId': categoryId,
      'isActive': isActive,
    };
  }

  Map<String, dynamic> toUpdateJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
    };
  }
}
