import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:drift/drift.dart' as drift;
import 'package:to_do_list/add/add_page.dart';
import 'package:to_do_list/data/app_database.dart';
import 'package:to_do_list/data/app_repository.dart';
import 'package:to_do_list/database/database_instance.dart';
import 'package:to_do_list/home/home_bloc.dart';
import 'package:to_do_list/pages/profile_page.dart';
import 'package:to_do_list/pages/settings_page.dart';
import 'package:to_do_list/pages/task_detail_page.dart';
import 'package:to_do_list/utils/date_formatter.dart';

class MyHomePage extends StatefulWidget {
  final String title;
  final Function(bool) onThemeToggle;

  const MyHomePage({
    super.key,
    required this.title,
    required this.onThemeToggle,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late final HomeCubit cubit;

  @override
  void initState() {
    super.initState();
    final repo = AppRepositoryImpl(appDatabase);
    final viewModel = HomeViewModel(repo);
    cubit = HomeCubit(viewModel);
    cubit.fetchList();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: cubit,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            widget.title,
            style: const TextStyle(fontWeight: FontWeight.normal),
          ),
          centerTitle: true,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfilePage()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        SettingsPage(onThemeToggle: widget.onThemeToggle),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            // Обработка ошибок
            if (state.isError) {
              return const Center(
                child: Text("Возникла ошибка при работе с данными!"),
              );
            }

            // Основной контент: список (если есть) или сообщение о пустоте + кнопка
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Expanded(
                    child: state.items.isEmpty
                        ? _buildEmptyStateContent()
                        : ListView.builder(
                            itemCount: state.items.length,
                            itemBuilder: (context, index) {
                              final task = state.items[index];
                              return GestureDetector(
                                onTap: () => _navigateToTaskDetail(task.id),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 16),
                                  decoration: BoxDecoration(
                                    color: Colors.blue,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: ListTile(
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    leading: Checkbox(
                                      value: task.isDone,
                                      onChanged: (_) => _toggleTaskStatus(task),
                                      fillColor: WidgetStateProperty.all(
                                        Colors.grey.shade300,
                                      ),
                                      checkColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    title: Text(
                                      task.title,
                                      style: TextStyle(
                                        decoration: task.isDone
                                            ? TextDecoration.lineThrough
                                            : null,
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    trailing: Text(
                                      formatDate(DateTime.parse(task.date)),
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _navigateToAddPage,
                      icon: const Icon(Icons.add, size: 20),
                      label: const Text(
                        'Добавить задачу',
                        style: TextStyle(fontSize: 16),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // Виджет для пустого состояния (без кнопки)
  Widget _buildEmptyStateContent() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Нет задач',
            style: TextStyle(fontSize: 18, color: Colors.grey[600]),
          ),
          const SizedBox(height: 8),
          Text(
            'Нажмите «+ Добавить задачу»\nчтобы создать новую задачу',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  void _toggleTaskStatus(Todo task) {
    final companion = TodosCompanion(
      title: drift.Value(task.title),
      description: drift.Value(task.description),
      date: drift.Value(task.date),
      isDone: drift.Value(!task.isDone),
    );
    cubit.updateTask(task.id, companion);
  }

  void _navigateToAddPage() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AddPage()),
    );
    await cubit.fetchList();
  }

  void _navigateToTaskDetail(int taskId) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TaskDetailPage(taskId: taskId)),
    );
    if (result == null) {
      await cubit.deleteTask(taskId);
    } else if (result is Todo) {
      final companion = TodosCompanion(
        title: drift.Value(result.title),
        description: drift.Value(result.description),
        date: drift.Value(result.date),
        isDone: drift.Value(result.isDone),
      );
      await cubit.updateTask(result.id, companion);
    }
  }
}
