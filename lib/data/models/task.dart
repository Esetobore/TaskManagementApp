import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String id;
  final String title;
  final String description;
  final String status;
  final DateTime dueDate;
  final List<String> tags;

  Task({
    required this.id,
    required this.title,
    required this.description,
    this.status = 'pending',
    required this.dueDate,
    this.tags = const [],
  });

  factory Task.fromJson(Map<String, dynamic> json) => Task(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        status: json['status'] ?? 'pending',
        dueDate: (json['dueDate'] as Timestamp).toDate(),
        tags: List<String>.from(json['tags']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'status': status,
        'dueDate': Timestamp.fromDate(dueDate),
        'tags': tags,
      };
}
