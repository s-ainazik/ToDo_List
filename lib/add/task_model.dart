// task_model.dart
class Task {
  final String title;
  final DateTime date;
  bool isCompleted;

  Task({
    required this.title,
    required this.date,
    this.isCompleted = false,
  });
}