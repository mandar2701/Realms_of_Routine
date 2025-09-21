import 'package:flutter/foundation.dart';

class TaskManager extends ChangeNotifier {
  List<String> tasks = [];
  int totalTasks = 0;
  int completedTasks = 0;

  void addTask(String task) {
    tasks.add(task);
    totalTasks++;
    notifyListeners();
  }

  // New method to clear all tasks
  void clearTasks() {
    tasks.clear();
    totalTasks = 0;
    completedTasks = 0;
    notifyListeners();
  }

  void removeTask(int index) {
    if (index < tasks.length) {
      tasks.removeAt(index);
      // The totalTasks count doesn't need to be decremented here
      // as the objective card's progress is based on tasks remaining vs tasks completed.
      // But if you want to track total tasks ever added, you'd need a different variable.
      // For this objective bar, this is correct.
      notifyListeners();
    }
  }

  void completeTask(int index) {
    if (index < tasks.length) {
      tasks.removeAt(index);
      completedTasks++;
      notifyListeners();
    }
  }
}
