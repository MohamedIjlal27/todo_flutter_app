import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';

class TodoProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Todo> _todos = [];
  bool _isLoading = false;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();
    await _storage.init();
    _todos = await _storage.getAllTodos();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addTodo(String title, {
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    String? imagePath,
  }) async {
    final todo = Todo(
      id: const Uuid().v4(),
      title: title,
      description: description,
      dueDate: dueDate,
      priority: priority,
      imagePath: imagePath,
    );
    _todos.add(todo);
    await _storage.saveTodo(todo);
    notifyListeners();
  }

  Future<void> updateTodo(Todo todo) async {
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index != -1) {
      _todos[index] = todo;
      await _storage.updateTodo(todo);
      notifyListeners();
    }
  }

  Future<void> deleteTodo(String id) async {
    _todos.removeWhere((todo) => todo.id == id);
    await _storage.deleteTodo(id);
    notifyListeners();
  }

  Future<void> toggleTodoStatus(String id) async {
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos[index];
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      _todos[index] = updatedTodo;
      await _storage.updateTodo(updatedTodo);
      notifyListeners();
    }
  }

  List<Todo> getFilteredTodos({
    bool? isCompleted,
    Priority? priority,
    String? searchQuery,
  }) {
    return _todos.where((todo) {
      bool matchesCompleted = isCompleted == null || todo.isCompleted == isCompleted;
      bool matchesPriority = priority == null || todo.priority == priority;
      bool matchesSearch = searchQuery == null || 
          searchQuery.isEmpty ||
          todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
          (todo.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
      
      return matchesCompleted && matchesPriority && matchesSearch;
    }).toList();
  }
} 