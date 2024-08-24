import 'dart:convert';
import 'package:consultation_app/models/category.dart';
import 'package:http/http.dart' as http;

class CategoryService {
  final String _apiUrl = 'http://consultationapp.runasp.net/api/category';

  Future<List<Category>> getAllCategories() async {
    final response = await http.get(Uri.parse(_apiUrl));

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((category) => Category.fromJson(category)).toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }

  Future<void> addCategory(Category category) async {
    final response = await http.post(
      Uri.parse(_apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to add a new category.');
    }
  }

  Future<void> updateCategory(Category category) async {
    final response = await http.put(
      Uri.parse('$_apiUrl/${category.id}'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(category.toJson()),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to update category.');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    final response = await http.delete(Uri.parse('$_apiUrl/$categoryId'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete category');
    }
  }
}
