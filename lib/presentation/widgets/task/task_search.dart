import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../data/providers/task_provider.dart';

class TaskSearchBar extends StatefulWidget {
  const TaskSearchBar({super.key});

  @override
  State<TaskSearchBar> createState() => _TaskSearchBarState();
}

class _TaskSearchBarState extends State<TaskSearchBar> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search tasks...',
          prefixIcon: const Icon(Icons.search, color: Colors.grey),
          suffixIcon: Consumer<TaskProvider>(
            builder: (context, taskProvider, _) {
              if (taskProvider.searchQuery.isEmpty) {
                return const SizedBox.shrink();
              }
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: () {
                  _searchController.clear();
                  taskProvider.setSearchQuery('');
                },
              );
            },
          ),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
        onChanged: (value) {
          context.read<TaskProvider>().setSearchQuery(value);
        },
      ),
    );
  }
}
