import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';
import '../models/category.dart';
import 'dart:convert';
import 'dart:collection';

class StorageService {
  static const String _todosBoxName = 'todos';
  static const String _categoriesBoxName = 'categories';
  static const String _pendingOpsBoxName = 'pending_operations';
  
  late Box<String> _todosBox;
  late Box<String> _categoriesBox;
  late Box<String> _pendingOpsBox;
  final Queue<Future<void> Function()> _pendingOperations = Queue();
  bool _isProcessingQueue = false;

  Future<void> init() async {
    await Hive.initFlutter();
    _todosBox = await Hive.openBox<String>(_todosBoxName);
    _categoriesBox = await Hive.openBox<String>(_categoriesBoxName);
    _pendingOpsBox = await Hive.openBox<String>(_pendingOpsBoxName);
    await _loadPendingOperations();
  }

  // Category methods
  Future<void> saveCategory(Category category) async {
    await _categoriesBox.put(category.id, jsonEncode(category.toJson()));
  }

  Future<void> deleteCategory(String id) async {
    await _categoriesBox.delete(id);
  }

  Future<void> updateCategory(Category category) async {
    await saveCategory(category);
  }

  Future<List<Category>> getAllCategories() async {
    try {
      return _categoriesBox.values
          .map((item) => Category.fromJson(jsonDecode(item)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Todo methods with pending operations
  Future<void> _loadPendingOperations() async {
    final pendingOps = _pendingOpsBox.values.toList();
    for (final op in pendingOps) {
      final Map<String, dynamic> operation = jsonDecode(op);
      switch (operation['type']) {
        case 'save':
          _pendingOperations.add(() => 
            _saveTodoImpl(Todo.fromJson(operation['data']))
          );
          break;
        case 'delete':
          _pendingOperations.add(() => 
            _deleteTodoImpl(operation['data'])
          );
          break;
        default:
          break;
      }
    }
    await _processPendingOperations();
  }

  Future<void> _processPendingOperations() async {
    if (_isProcessingQueue) return;
    _isProcessingQueue = true;

    try {
      while (_pendingOperations.isNotEmpty) {
        final operation = _pendingOperations.removeFirst();
        try {
          await operation();
          await _pendingOpsBox.deleteAt(0);
        } catch (e) {
          _pendingOperations.addFirst(operation);
          break;
        }
      }
    } finally {
      _isProcessingQueue = false;
    }
  }

  Future<void> _enqueuePendingOperation(String type, dynamic data) async {
    final operation = {
      'type': type,
      'data': data,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _pendingOpsBox.add(jsonEncode(operation));
  }

  Future<void> _saveTodoImpl(Todo todo) async {
    await _todosBox.put(todo.id, jsonEncode(todo.toJson()));
  }

  Future<void> saveTodo(Todo todo) async {
    try {
      await _saveTodoImpl(todo);
    } catch (e) {
      await _enqueuePendingOperation('save', todo.toJson());
      rethrow;
    }
  }

  Future<void> _deleteTodoImpl(String id) async {
    await _todosBox.delete(id);
  }

  Future<void> deleteTodo(String id) async {
    try {
      await _deleteTodoImpl(id);
    } catch (e) {
      await _enqueuePendingOperation('delete', id);
      rethrow;
    }
  }

  Future<List<Todo>> getAllTodos() async {
    try {
      return _todosBox.values
          .map((item) => Todo.fromJson(jsonDecode(item)))
          .toList();
    } catch (e) {
      return [];
    }
  }

  Future<void> updateTodo(Todo todo) async {
    await saveTodo(todo);
  }

  Future<void> clearAll() async {
    await _todosBox.clear();
    await _categoriesBox.clear();
    await _pendingOpsBox.clear();
    _pendingOperations.clear();
  }
} 