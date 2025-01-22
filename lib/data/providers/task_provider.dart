import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dufil/data/models/task.dart';
import 'package:dufil/data/repos/task_repo.dart';
import 'package:flutter/foundation.dart';

class TaskProvider with ChangeNotifier {
  final TaskRepository _taskRepository;
  List<Task> _tasks = [];
  List<Task> _filteredTasks = [];
  Map<String, int> _statistics = {
    'completed': 0,
    'pending': 0,
    'in_progress': 0,
    'in_review': 0,
    'on_hold': 0,
  };
  bool _isLoading = false;
  String? _filterStatus;
  String _searchQuery = '';
  StreamSubscription<QuerySnapshot>? _tasksSubscription;

  TaskProvider(this._taskRepository) {
    _initializeStreams();
  }

  List<Task> get tasks => _searchQuery.isEmpty ? _tasks : _filteredTasks;
  Map<String, int> get statistics => _statistics;
  bool get isLoading => _isLoading;
  String? get filterStatus => _filterStatus;
  String get searchQuery => _searchQuery;

  void _initializeStreams() {
    _subscribeToTasks();
  }

  // Subscribe to task updates from the repository.
  void _subscribeToTasks() {
    _tasksSubscription?.cancel();
    _tasksSubscription = _taskRepository.getTasksForStats().listen((snapshot) {
      if (_filterStatus != null) {
        _tasks = snapshot.docs
            .map((doc) {
              final data = doc.data() as Map<String, dynamic>;
              return Task.fromJson({...data, 'id': doc.id});
            })
            .where((task) => task.status == _filterStatus)
            .toList();
      } else {
        _tasks = snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          return Task.fromJson({...data, 'id': doc.id});
        }).toList();
      }
      _updateStatistics(snapshot);
      _filterTasks();
      notifyListeners();
    });
  }

  // Update statistics based on the task snapshot.
  void _updateStatistics(QuerySnapshot snapshot) {
    _statistics = {
      'completed': 0,
      'pending': 0,
      'in_progress': 0,
      'in_review': 0,
      'on_hold': 0,
    };

    for (var doc in snapshot.docs) {
      final data = doc.data() as Map<String, dynamic>;
      final status = data['status'] as String? ?? 'pending';
      _statistics[status] = (_statistics[status] ?? 0) + 1;
    }
  }

  // Set the search query for filtering tasks.
  void setSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    _filterTasks();
    notifyListeners();
  }

  // Filter tasks based on the search query.
  void _filterTasks() {
    if (_searchQuery.isEmpty) {
      _filteredTasks = List.from(_tasks);
      return;
    }

    _filteredTasks = _tasks.where((task) {
      final title = task.title.toLowerCase();
      final description = task.description.toLowerCase();
      return title.contains(_searchQuery) || description.contains(_searchQuery);
    }).toList();
  }

  // Create a new task and notify listeners.
  Future<void> createTask(Task task) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _taskRepository.createTask(
        title: task.title,
        description: task.description,
        dueDate: task.dueDate,
        tags: task.tags,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error creating task: $e');
    }
  }

  // Update an existing task and notify listeners.
  Future<void> updateTask(Task task) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _taskRepository.updateTask(
        taskId: task.id,
        title: task.title,
        description: task.description,
        status: task.status,
        dueDate: task.dueDate,
        tags: task.tags,
      );
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error updating task: $e');
    }
  }

  // Delete a task and notify listeners.
  Future<void> deleteTask(String taskId) async {
    try {
      _isLoading = true;
      notifyListeners();
      await _taskRepository.deleteTask(taskId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      throw Exception('Error deleting task: $e');
    }
  }

  // Set the filter status and refresh task subscription.
  void setFilter(String? status) {
    _filterStatus = status;
    _subscribeToTasks();
  }

  // Fetch task statistics from the repository.
  Future<void> fetchTaskStatistics() async {
    try {
      _statistics = await _taskRepository.getTaskStatistics();
      notifyListeners();
    } catch (e) {
      throw Exception('Error fetching statistics: $e');
    }
  }

  // Clean up resources by canceling the task subscription.
  @override
  void dispose() {
    _tasksSubscription?.cancel();
    super.dispose();
  }
}
