import 'package:consultation_app/services/category_service.dart';
import 'package:flutter/material.dart';
import '../models/category.dart';

class CategoryViewModel extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();
  List<Category> _categories = [];
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  List<Category> get getCategories => _categories;

  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      _categories = await _categoryService.getAllCategories();
    } catch (e) {
      throw Exception('Error fetching categories.');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addCategory(Category category) async {
    try {
      await _categoryService.addCategory(category);
      await fetchCategories();
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to create category');
    }
  }

  Future<void> updateCategory(Category category) async {
    try {
      await _categoryService.updateCategory(category);
      await fetchCategories();
    } catch (e) {
      throw Exception('Failed to update category');
    }
  }

  Future<void> deleteCategory(int categoryId) async {
    try {
      await _categoryService.deleteCategory(categoryId);
      await fetchCategories();
    } catch (e) {
      throw Exception('Failed to delete category');
    }
  }
}
