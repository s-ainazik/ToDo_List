import 'package:to_do_list/data/app_database.dart';

abstract class AppRepository {
  Future<List<Todo>> getList();
  Future<Todo?> getTaskById(int id);
  Future<void> addTask(TodosCompanion companion);
  Future<void> updateTask(int id, TodosCompanion companion);
  Future<void> deleteTask(int id);
}

class AppRepositoryImpl implements AppRepository {
  final AppDatabase db;
  AppRepositoryImpl(this.db);

  @override
  Future<List<Todo>> getList() => db.getTodoList();

  @override
  Future<Todo?> getTaskById(int id) async {
    return await (db.select(db.todos)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  @override
  Future<void> addTask(TodosCompanion companion) async {
    await db.insertTodo(companion);
  }

  @override
  Future<void> updateTask(int id, TodosCompanion companion) async {
    await db.updateTodo(id, companion);
  }

  @override
  Future<void> deleteTask(int id) async {
    await db.deleteTodo(id);
  }
}