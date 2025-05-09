import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/todo.dart';
import '../models/category.dart';
import '../providers/todo_provider.dart';
import '../providers/category_provider.dart';
import 'todo_item.dart';
import 'todo_detail_sheet.dart';

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
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (todos.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.task_alt,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No tasks yet',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
                  ),
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      itemCount: todos.length,
      onReorderStart: (index) {
        // Optional: Add haptic feedback
        HapticFeedback.mediumImpact();
      },
      onReorder: (oldIndex, newIndex) {
        context.read<TodoProvider>().reorderTodo(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final todo = todos[index];
        final category = todo.categoryId != null
            ? context.read<CategoryProvider>().getCategoryById(todo.categoryId!)
            : null;

        return Dismissible(
          key: Key(todo.id),
          background: Container(
            color: Colors.red,
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 16),
            child: const Icon(
              Icons.delete,
              color: Colors.white,
            ),
          ),
          direction: DismissDirection.endToStart,
          confirmDismiss: (direction) async {
            return await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Delete Task'),
                content: const Text('Are you sure you want to delete this task?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Delete'),
                  ),
                ],
              ),
            ) ??
                false;
          },
          onDismissed: (direction) {
            context.read<TodoProvider>().deleteTodo(todo.id);
          },
          child: TodoItem(
            todo: todo,
            category: category,
            onTap: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) => TodoDetailSheet(todo: todo),
              );
            },
          ),
        );
      },
    );
  }
} 