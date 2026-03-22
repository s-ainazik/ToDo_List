import 'package:to_do_list/add/todo.dart';
import 'package:to_do_list/data/repository.dart';

class AddVm {
  final Repository repo;

  AddVm(this.repo);

  Future<Todo> addTask(String title) async {
    final task = Todo(
      id: 0,
      title: title,
      date: DateTime.now(),
    );
    await repo.addTask(task);
    return task;
  }
}