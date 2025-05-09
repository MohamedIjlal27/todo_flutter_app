import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../models/todo.dart';
import '../models/category.dart';
import '../providers/todo_provider.dart';
import 'todo_detail_sheet.dart';

class TodoItem extends StatelessWidget {
  final Todo todo;
  final Category? category;
  final VoidCallback? onTap;

  const TodoItem({
    super.key,
    required this.todo,
    this.category,
    this.onTap,
  });

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.low:
        return Colors.green;
      case Priority.medium:
        return Colors.orange;
      case Priority.high:
        return Colors.red;
    }
  }

  void _showTodoDetail(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => TodoDetailSheet(todo: todo),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Slidable(
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) {
                context.read<TodoProvider>().deleteTodo(todo.id);
              },
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: InkWell(
            onTap: onTap ?? () => _showTodoDetail(context),
            borderRadius: BorderRadius.circular(8),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.drag_handle,
                        color: Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.5),
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      if (category != null) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: category!.color.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                category!.icon,
                                color: category!.color,
                                size: 16,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                category!.name,
                                style: TextStyle(
                                  color: category!.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Expanded(
                        child: Text(
                          todo.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            decoration:
                                todo.isCompleted ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      Checkbox(
                        value: todo.isCompleted,
                        onChanged: (value) {
                          if (value != null) {
                            context
                                .read<TodoProvider>()
                                .toggleTodoStatus(todo.id);
                          }
                        },
                      ),
                    ],
                  ),
                  if (todo.description?.isNotEmpty ?? false) ...[
                    const SizedBox(height: 8),
                    Text(
                      todo.description!,
                      style: TextStyle(
                        color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ],
                  if (todo.dueDate != null || todo.priority != null) ...[
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (todo.dueDate != null) ...[
                          Icon(
                            Icons.calendar_today,
                            size: 16,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${todo.dueDate!.day}/${todo.dueDate!.month}/${todo.dueDate!.year}',
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.primary,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 16),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: _getPriorityColor(todo.priority).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            todo.priority.name.toUpperCase(),
                            style: TextStyle(
                              color: _getPriorityColor(todo.priority),
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                  if (todo.imagePath != null) ...[
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.file(
                        File(todo.imagePath!),
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}