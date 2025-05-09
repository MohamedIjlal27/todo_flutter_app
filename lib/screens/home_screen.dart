import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/todo_provider.dart';
import '../providers/theme_provider.dart';
import '../models/todo.dart';
import '../widgets/todo_search_bar.dart';
import '../widgets/todo_filter_chips.dart';
import '../widgets/todo_list.dart';
import '../widgets/add_todo_sheet.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Priority? _selectedPriority;
  bool? _selectedStatus;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<TodoProvider>().init();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddTodoSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const AddTodoSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final todoProvider = context.watch<TodoProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Tasks'),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TodoSearchBar(
                  controller: _searchController,
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TodoFilterChips(
                  selectedStatus: _selectedStatus,
                  selectedPriority: _selectedPriority,
                  onStatusSelected: (value) {
                    setState(() {
                      _selectedStatus = value;
                    });
                  },
                  onPrioritySelected: (value) {
                    setState(() {
                      _selectedPriority = value;
                    });
                  },
                ),
              ],
            ),
          ),
          Expanded(
            child: TodoList(
              todos: todoProvider.getFilteredTodos(
                isCompleted: _selectedStatus,
                priority: _selectedPriority,
                searchQuery: _searchQuery,
              ),
              isLoading: todoProvider.isLoading,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showAddTodoSheet,
        label: const Text('Add New Task'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}