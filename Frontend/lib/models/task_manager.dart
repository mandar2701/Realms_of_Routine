class TaskManager {
  static final TaskManager instance = TaskManager._internal();

  TaskManager._internal();

  List<String> tasks = [];
  int completedTasks = 0;

  void addTask(String task) {
    tasks.add(task);
  }

  void removeTask(int index) {
    tasks.removeAt(index);
  }

  void completeTask(int index) {
    completedTasks++;
    tasks.removeAt(index);
  }
}
