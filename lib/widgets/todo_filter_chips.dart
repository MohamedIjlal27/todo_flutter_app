import 'package:flutter/material.dart';
import '../models/todo.dart';

class TodoFilterChips extends StatelessWidget {
  final bool? selectedStatus;
  final Priority? selectedPriority;
  final Function(bool?) onStatusSelected;
  final Function(Priority?) onPrioritySelected;

  const TodoFilterChips({
    super.key,
    required this.selectedStatus,
    required this.selectedPriority,
    required this.onStatusSelected,
    required this.onPrioritySelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('All'),
            selected: selectedStatus == null,
            onSelected: (selected) => onStatusSelected(null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Active'),
            selected: selectedStatus == false,
            onSelected: (selected) => onStatusSelected(selected ? false : null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Completed'),
            selected: selectedStatus == true,
            onSelected: (selected) => onStatusSelected(selected ? true : null),
          ),
          const SizedBox(width: 16),
          FilterChip(
            label: const Text('Low Priority'),
            selected: selectedPriority == Priority.low,
            onSelected: (selected) => 
                onPrioritySelected(selected ? Priority.low : null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('Medium Priority'),
            selected: selectedPriority == Priority.medium,
            onSelected: (selected) =>
                onPrioritySelected(selected ? Priority.medium : null),
          ),
          const SizedBox(width: 8),
          FilterChip(
            label: const Text('High Priority'),
            selected: selectedPriority == Priority.high,
            onSelected: (selected) =>
                onPrioritySelected(selected ? Priority.high : null),
          ),
        ],
      ),
    );
  }
} 