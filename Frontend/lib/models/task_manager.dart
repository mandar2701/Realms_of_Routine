import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/task_service.dart';
import '../providers/user_provider.dart';
import 'tasks.dart';

class TaskManager extends ChangeNotifier {
  List<Task> _tasks = [];
  final TaskService _taskService = TaskService();

  List<Task> get tasks => _tasks;

  // READ (Load from MongoDB)
  Future<void> loadTasks(BuildContext context) async {
    final token = Provider.of<UserProvider>(context, listen: false).user.token;
    if (token.isEmpty) return;

    try {
      _tasks = await _taskService.fetchTasks(token);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error loading tasks from MongoDB: $e');
      }
    }
  }

  // CREATE (Save to MongoDB)
  Future<void> addTask(Task newTask, String token) async {
    try {
      final createdTask = await _taskService.createTask(newTask, token);
      _tasks.add(createdTask);
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error creating task in MongoDB: $e');
      }
      rethrow;
    }
  }

  // UPDATE (Mark Completed in MongoDB)
  Future<void> completeTask(Task task, String token) async {
    if (task.status != TaskStatus.pending || task.id == null) return;

    final updatedTask = Task(
      id: task.id,
      name: task.name,
      priority: task.priority, // ✅ FIX: Was 'difficulty'
      status: TaskStatus.completed,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      description: task.description,
    );

    try {
      await _taskService.updateTask(updatedTask, token);

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks[index] = updatedTask;
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error completing task in MongoDB: $e');
      }
      rethrow;
    }
  }

  // UPDATE (Mark Deleted/Soft Delete in MongoDB)
  Future<void> deleteTask(Task task, String token) async {
    if (task.id == null) return;

    final deletedTask = Task(
      id: task.id,
      name: task.name,
      priority: task.priority, // ✅ FIX: Was 'difficulty'
      status: TaskStatus.deleted,
      createdAt: task.createdAt,
      dueDate: task.dueDate,
      description: task.description,
    );

    try {
      await _taskService.updateTask(deletedTask, token);

      final index = _tasks.indexWhere((t) => t.id == task.id);
      if (index != -1) {
        _tasks.removeAt(index);
        notifyListeners();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting task in MongoDB: $e');
      }
      rethrow;
    }
  }

  void clearTasks() {
    _tasks.clear();
    notifyListeners();
  }

  // Local getters
  int get totalTasks =>
      _tasks.where((task) => task.status != TaskStatus.deleted).length;

  int get completedTasks =>
      _tasks.where((task) => task.status == TaskStatus.completed).length;

  List<Task> get activeTasks =>
      _tasks
          .where(
            (task) =>
                task.status != TaskStatus.deleted &&
                task.status != TaskStatus.completed,
          )
          .toList();
}
