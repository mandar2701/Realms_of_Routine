import 'dart:convert';

enum TaskStatus { pending, completed, deleted }

extension TaskStatusExtension on TaskStatus {
  String toShortString() {
    return toString().split('.').last;
  }
}

class Task {
  final String? id;
  final String name;
  final String priority;
  TaskStatus status;
  final String? description;

  final DateTime createdAt;
  final DateTime dueDate;

  Task({
    this.id,
    required this.name,
    this.description,
    required this.priority,
    this.status = TaskStatus.pending,
    DateTime? createdAt,
    DateTime? dueDate,
  }) : createdAt = createdAt ?? DateTime.now(),
       dueDate = dueDate ?? DateTime.now().add(const Duration(days: 7));

  factory Task.fromJson(Map<String, dynamic> json) {
    DateTime _parseSafeDate(
      dynamic dateValue, {
      required DateTime defaultDate,
    }) {
      if (dateValue == null) return defaultDate;

      if (dateValue is Map && dateValue.containsKey('\$date')) {
        final dateMap = dateValue['\$date'];
        if (dateMap is Map && dateMap.containsKey('\$numberLong')) {
          final timestamp = int.tryParse(dateMap['\$numberLong']) ?? 0;
          return DateTime.fromMillisecondsSinceEpoch(timestamp);
        }
      }

      if (dateValue is String) {
        try {
          return DateTime.parse(dateValue);
        } catch (e) {
          return defaultDate;
        }
      }

      return defaultDate;
    }

    TaskStatus _parseStatus(String? statusString) {
      switch (statusString?.toLowerCase()) {
        case 'completed':
          return TaskStatus.completed;
        case 'deleted':
          return TaskStatus.deleted;
        default:
          return TaskStatus.pending;
      }
    }

    return Task(
      id: json['_id'] is Map ? json['_id']['\$oid'] : json['_id'],
      name: json['name'] ?? 'Untitled Task',
      priority: json['difficulty'] ?? 'low',
      status: _parseStatus(json['status']),
      description: json['description'],
      createdAt: _parseSafeDate(json['createdAt'], defaultDate: DateTime.now()),
      dueDate: _parseSafeDate(
        json['dueDate'],
        defaultDate: DateTime.now().add(const Duration(days: 1)),
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'difficulty': priority,
      'status': status.toShortString(),
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate.toIso8601String(),
      'description': description,
    };
  }
}
