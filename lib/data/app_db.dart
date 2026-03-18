import 'package:to_do_list/add/todo.dart';

class AppDb {
  final List<Todo> _tasks = [];

  Future<void> insertTask(Todo task) async {
    _tasks.add(task);
  }

  List<Todo> getTasks() {
    return _tasks;
  }
}