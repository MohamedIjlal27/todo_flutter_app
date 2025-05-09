import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Consumer<ThemeProvider>(
              builder: (context, themeProvider, child) {
                return SwitchListTile(
                  title: const Text('Dark Mode'),
                  subtitle: Text(
                    themeProvider.isDarkMode ? 'Dark theme enabled' : 'Light theme enabled',
                  ),
                  value: themeProvider.isDarkMode,
                  onChanged: (value) => themeProvider.toggleTheme(),
                  secondary: Icon(
                    themeProvider.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              subtitle: const Text('Todo App v1.0.0'),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'Todo App',
                  applicationVersion: '1.0.0',
                  applicationIcon: const FlutterLogo(size: 64),
                  children: [
                    const Text(
                      'A feature-rich todo app built with Flutter. '
                      'Manage your tasks with categories, priorities, and more.',
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
} 