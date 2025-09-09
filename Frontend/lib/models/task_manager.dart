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

  void removeTask(int index) {
    if (index < tasks.length) {
      tasks.removeAt(index);
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
