import 'package:flutter/material.dart';
import '../models/todo.dart';
import 'todo_item.dart';
import 'empty_state.dart';

class TodoList extends StatelessWidget {
  final List<Todo> todos;
  final bool isLoading;

  const TodoList({
    super.key,
    required this.todos,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (todos.isEmpty) {
      return const EmptyState(
        icon: Icons.task_alt,
        message: 'No tasks found',
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: todos.length,
      itemBuilder: (context, index) {
        return TodoItem(todo: todos[index]);
      },
    );
  }
} 