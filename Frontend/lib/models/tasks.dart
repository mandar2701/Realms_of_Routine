enum TaskStatus { pending, completed, deleted }

class Task {
  final String name;
  final String difficulty;
  TaskStatus status;

  Task({
    required this.name,
    required this.difficulty,
    this.status = TaskStatus.pending,
  });
}
