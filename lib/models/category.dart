class Category {
  final int? id;
  final String name;

  Category({this.id, required this.name});

  factory Category.fromJson(Map<String, dynamic> jsonData) {
    return Category(
      id: jsonData['id'],
      name: jsonData['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
    };
  }
}
