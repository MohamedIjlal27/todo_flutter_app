import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/category.dart';
import '../services/storage_service.dart';

class CategoryProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Category> _categories = [];
  bool _isLoading = false;
  String? _error;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;
  String? get error => _error;

  static final List<Category> defaultCategories = [
    Category(
      id: 'personal',
      name: 'Personal',
      color: Colors.blue,
      icon: Icons.person,
    ),
    Category(
      id: 'work',
      name: 'Work',
      color: Colors.red,
      icon: Icons.work,
    ),
    Category(
      id: 'shopping',
      name: 'Shopping',
      color: Colors.green,
      icon: Icons.shopping_cart,
    ),
    Category(
      id: 'health',
      name: 'Health',
      color: Colors.purple,
      icon: Icons.favorite,
    ),
  ];

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  Future<void> init() async {
    _setLoading(true);
    _setError(null);
    try {
      await _storage.init();
      _categories = await _storage.getAllCategories();
      
      if (_categories.isEmpty) {
        _categories = defaultCategories;
        for (final category in _categories) {
          await _storage.saveCategory(category);
        }
      }
    } catch (e) {
      _setError('Failed to initialize categories: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addCategory(String name, Color color, IconData icon) async {
    _setLoading(true);
    _setError(null);
    try {
      final category = Category(
        id: const Uuid().v4(),
        name: name,
        color: color,
        icon: icon,
      );
      _categories.add(category);
      await _storage.saveCategory(category);
      notifyListeners();
    } catch (e) {
      _categories.removeLast();
      _setError('Failed to add category: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateCategory(Category category) async {
    _setLoading(true);
    _setError(null);
    final index = _categories.indexWhere((c) => c.id == category.id);
    if (index == -1) {
      _setError('Category not found');
      _setLoading(false);
      return;
    }

    final oldCategory = _categories[index];
    try {
      _categories[index] = category;
      await _storage.updateCategory(category);
      notifyListeners();
    } catch (e) {
      _categories[index] = oldCategory;
      _setError('Failed to update category: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteCategory(String id) async {
    _setLoading(true);
    _setError(null);
    final index = _categories.indexWhere((c) => c.id == id);
    if (index == -1) {
      _setError('Category not found');
      _setLoading(false);
      return;
    }

    final oldCategory = _categories[index];
    try {
      _categories.removeAt(index);
      await _storage.deleteCategory(id);
      notifyListeners();
    } catch (e) {
      _categories.insert(index, oldCategory);
      _setError('Failed to delete category: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Category? getCategoryById(String id) {
    try {
      return _categories.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }
} 