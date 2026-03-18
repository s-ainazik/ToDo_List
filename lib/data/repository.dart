import 'package:to_do_list/add/todo.dart';
import 'package:to_do_list/data/app_db.dart';

class Repository {
  final AppDb database;

  Repository(this.database);

  Future<void> addTask(Todo task) async {
    await database.insertTask(task);
  }
}