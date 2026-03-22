class Todo {
  int id;
  final String title;
  final DateTime date;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    required this.date,
    this.isDone = false,
  });
}