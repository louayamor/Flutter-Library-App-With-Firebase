import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/category_service.dart';

class CategoryController extends ChangeNotifier {
  final CategoryService _categoryService = CategoryService();

  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  CategoryController() {
    fetchCategories();
  }

  /// Fetch categories from Firestore and listen for real-time updates
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    _categoryService.getCategories().listen((categoryList) {
      _categories = categoryList;
      _isLoading = false;
      notifyListeners();
    }, onError: (error) {
      _isLoading = false;
      notifyListeners();
      debugPrint('Error fetching categories: $error');
    });
  }

  /// Add a new category
  Future<void> addCategory(Category category) async {
    try {
      await _categoryService.addCategory(category);
      debugPrint('Category added: ${category.name}');
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }

  /// Delete a category
  Future<void> deleteCategory(String id) async {
    try {
      await _categoryService.deleteCategory(id);
      debugPrint('Category deleted: $id');
    } catch (e) {
      debugPrint('Error deleting category: $e');
    }
  }

  /// Update a category
  Future<void> updateCategory(Category category) async {
    try {
      await _categoryService.updateCategory(category);
      debugPrint('Category updated: ${category.name}');
    } catch (e) {
      debugPrint('Error updating category: $e');
    }
  }
}
