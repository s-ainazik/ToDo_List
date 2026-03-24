class Todo {
  int id;
  final String title;
  final String description;
  final DateTime date;
  bool isDone;

  Todo({
    required this.id,
    required this.title,
    this.description = '' ,
    required this.date,
    this.isDone = false,
  });
}