import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';
import '../services/storage_service.dart';

class TodoProvider extends ChangeNotifier {
  final StorageService _storage = StorageService();
  List<Todo> _todos = [];
  bool _isLoading = false;
  String? _error;

  List<Todo> get todos => _todos;
  bool get isLoading => _isLoading;
  String? get error => _error;

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
      _todos = await _storage.getAllTodos();
    } catch (e) {
      _setError('Failed to initialize: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTodo(String title, {
    String? description,
    DateTime? dueDate,
    Priority priority = Priority.medium,
    String? imagePath,
  }) async {
    _setLoading(true);
    _setError(null);
    try {
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
    } catch (e) {
      _setError('Failed to add todo: ${e.toString()}');
      _todos.removeLast(); // Rollback optimistic update
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateTodo(Todo todo) async {
    _setLoading(true);
    _setError(null);
    final index = _todos.indexWhere((t) => t.id == todo.id);
    if (index == -1) {
      _setError('Todo not found');
      _setLoading(false);
      return;
    }

    final oldTodo = _todos[index];
    try {
      _todos[index] = todo;
      await _storage.updateTodo(todo);
      notifyListeners();
    } catch (e) {
      _todos[index] = oldTodo; // Rollback optimistic update
      _setError('Failed to update todo: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> deleteTodo(String id) async {
    _setLoading(true);
    _setError(null);
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      _setError('Todo not found');
      _setLoading(false);
      return;
    }

    final oldTodo = _todos[index];
    try {
      _todos.removeAt(index);
      await _storage.deleteTodo(id);
      notifyListeners();
    } catch (e) {
      _todos.insert(index, oldTodo); // Rollback optimistic update
      _setError('Failed to delete todo: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> toggleTodoStatus(String id) async {
    _setError(null);
    final index = _todos.indexWhere((todo) => todo.id == id);
    if (index == -1) {
      _setError('Todo not found');
      return;
    }

    final oldTodo = _todos[index];
    try {
      final updatedTodo = oldTodo.copyWith(isCompleted: !oldTodo.isCompleted);
      _todos[index] = updatedTodo;
      await _storage.updateTodo(updatedTodo);
      notifyListeners();
    } catch (e) {
      _todos[index] = oldTodo; // Rollback optimistic update
      _setError('Failed to update todo status: ${e.toString()}');
    }
  }

  List<Todo> getFilteredTodos({
    bool? isCompleted,
    Priority? priority,
    String? searchQuery,
  }) {
    try {
      return _todos.where((todo) {
        bool matchesCompleted = isCompleted == null || todo.isCompleted == isCompleted;
        bool matchesPriority = priority == null || todo.priority == priority;
        bool matchesSearch = searchQuery == null || 
            searchQuery.isEmpty ||
            todo.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
            (todo.description?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false);
        
        return matchesCompleted && matchesPriority && matchesSearch;
      }).toList();
    } catch (e) {
      _setError('Failed to filter todos: ${e.toString()}');
      return [];
    }
  }

  void clearError() {
    _setError(null);
  }
} 