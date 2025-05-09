import 'package:hive_flutter/hive_flutter.dart';
import '../models/todo.dart';
import 'dart:convert';

class StorageService {
  static const String _boxName = 'todos';
  late Box<String> _box;

  Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox<String>(_boxName);
  }

  Future<void> saveTodo(Todo todo) async {
    await _box.put(todo.id, jsonEncode(todo.toJson()));
  }

  Future<void> deleteTodo(String id) async {
    await _box.delete(id);
  }

  Future<List<Todo>> getAllTodos() async {
    return _box.values
        .map((item) => Todo.fromJson(jsonDecode(item)))
        .toList();
  }

  Future<void> updateTodo(Todo todo) async {
    await saveTodo(todo);
  }

  Future<void> clearAll() async {
    await _box.clear();
  }
} 