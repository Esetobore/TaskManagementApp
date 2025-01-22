import 'package:cloud_firestore/cloud_firestore.dart';

class TaskRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String userId;

  TaskRepository({required this.userId});

  // Create a new task
  Future<String> createTask({
    required String title,
    required String description,
    required DateTime dueDate,
    List<String>? tags,
  }) async {
    try {
      final taskDoc = await _firestore.collection('tasks').add({
        'userId': userId,
        'title': title,
        'description': description,
        'status': 'pending',
        'dueDate': Timestamp.fromDate(dueDate),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
        'tags': tags ?? [],
      });

      return taskDoc.id;
    } catch (e) {
      throw Exception('Failed to create task: $e');
    }
  }

  // Get all tasks for the current user
  Stream<QuerySnapshot> getTasks({String? status}) {
    Query query = _firestore.collection('tasks').where('userId', isEqualTo: userId).orderBy('dueDate');

    if (status != null) {
      query = query.where('status', isEqualTo: status);
    }

    return query.snapshots();
  }

  // Update task
  Future<void> updateTask({
    required String taskId,
    String? title,
    String? description,
    String? status,
    DateTime? dueDate,
    List<String>? tags,
  }) async {
    try {
      await _firestore.collection('tasks').doc(taskId).update({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (status != null) 'status': status,
        if (dueDate != null) 'dueDate': Timestamp.fromDate(dueDate),
        if (tags != null) 'tags': tags,
        'updatedAt': Timestamp.now(),
      });
    } catch (e) {
      throw Exception('Failed to update task: $e');
    }
  }

  // Delete task
  Future<void> deleteTask(String taskId) async {
    try {
      await _firestore.collection('tasks').doc(taskId).delete();
    } catch (e) {
      throw Exception('Failed to delete task: $e');
    }
  }

  // Get task statistics
  Future<Map<String, int>> getTaskStatistics() async {
    try {
      final QuerySnapshot pending = await _firestore.collection('tasks').where('userId', isEqualTo: userId).where('status', isEqualTo: 'pending').get();

      final QuerySnapshot inProgress = await _firestore.collection('tasks').where('userId', isEqualTo: userId).where('status', isEqualTo: 'in_progress').get();

      final QuerySnapshot completed = await _firestore.collection('tasks').where('userId', isEqualTo: userId).where('status', isEqualTo: 'completed').get();

      final QuerySnapshot onHold = await _firestore.collection('tasks').where('userId', isEqualTo: userId).where('status', isEqualTo: 'on_hold').get();

      return {
        'pending': pending.size,
        'in_progress': inProgress.size,
        'completed': completed.size,
        'on_hold': onHold.size,
      };
    } catch (e) {
      throw Exception('Failed to get task statistics: $e');
    }
  }

  Stream<QuerySnapshot> getTasksForStats() {
    return _firestore.collection('tasks').where('userId', isEqualTo: userId).snapshots();
  }
}
