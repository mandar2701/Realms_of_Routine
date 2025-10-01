import 'package:flutter/foundation.dart';

import 'tasks.dart';

class TaskManager extends ChangeNotifier {
  List<Task> tasks = [];

  void addTask(Task task) {
    tasks.add(task);
    notifyListeners();
  }

  void completeTask(int index) {
    if (index < tasks.length && tasks[index].status == TaskStatus.pending) {
      tasks[index].status = TaskStatus.completed;
      notifyListeners();
    }
  }

  void deleteTask(int index) {
    if (index < tasks.length) {
      tasks[index].status = TaskStatus.deleted;
      notifyListeners();
    }
  }

  void clearTasks() {
    tasks.clear();
    notifyListeners();
  }

  int get totalTasks =>
      tasks.where((task) => task.status != TaskStatus.deleted).length;

  int get completedTasks =>
      tasks.where((task) => task.status == TaskStatus.completed).length;

  int get pendingTasks =>
      tasks.where((task) => task.status == TaskStatus.pending).length;

  List<Task> get activeTasks =>
      tasks.where((task) => task.status != TaskStatus.deleted).toList();
}
