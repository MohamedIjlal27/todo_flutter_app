import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';
import 'dart:convert';
import 'dart:collection';

class StorageService {
  static const String _boxName = 'todos';
  static const String _pendingOpsBoxName = 'pending_operations';
  late Box<String> _box;
  late Box<String> _pendingOpsBox;
  final Queue<Future<void> Function()> _pendingOperations = Queue();
  bool _isProcessingQueue = false;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
    _pendingOpsBox = await Hive.openBox<String>(_pendingOpsBoxName);
    await _loadPendingOperations();
  }

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
          // Remove the operation from pending box after successful execution
          await _pendingOpsBox.deleteAt(0);
        } catch (e) {
          // If operation fails, add it back to the queue
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
    await _box.put(todo.id, jsonEncode(todo.toJson()));
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
    await _box.delete(id);
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
      return _box.values
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
    await _box.clear();
    await _pendingOpsBox.clear();
    _pendingOperations.clear();
  }
} 