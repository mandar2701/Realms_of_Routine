import 'package:flutter/foundation.dart';

class TaskManager extends ChangeNotifier {
  final List<String> _tasks = [];

  List<String> get tasks => List.unmodifiable(_tasks);

  void addTask(String task) {
    _tasks.add(task);
    notifyListeners();
  }

  void removeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      _tasks.removeAt(index);
      notifyListeners();
    }
  }

  void completeTask(int index) {
    if (index >= 0 && index < _tasks.length) {
      // Here you can mark completed or move to another list
      _tasks.removeAt(index);
      notifyListeners();
    }
  }
}
