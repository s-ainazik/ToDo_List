import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/data/app_database.dart';
import 'package:to_do_list/database/database_instance.dart';
import 'package:to_do_list/data/app_repository.dart';
import 'package:to_do_list/detail/detail_bloc.dart';

class TaskDetailPage extends StatelessWidget {
  final int taskId;
  const TaskDetailPage({super.key, required this.taskId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = AppRepositoryImpl(appDatabase);
        final viewModel = DetailViewModel(repo);
        final cubit = DetailCubit(viewModel);
        cubit.loadTask(taskId);
        return cubit;
      },
      child: const _TaskDetailContent(),
    );
  }
}

class _TaskDetailContent extends StatefulWidget {
  const _TaskDetailContent();

  @override
  State<_TaskDetailContent> createState() => _TaskDetailContentState();
}

class _TaskDetailContentState extends State<_TaskDetailContent> {
  late final TextEditingController _controller;
  bool _isDescriptionEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onDescriptionChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() {
    final isEmpty = _controller.text.trim().isEmpty;
    if (isEmpty != _isDescriptionEmpty) {
      setState(() => _isDescriptionEmpty = isEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DetailCubit, DetailState>(
      listener: (context, state) {
        // Обновляем контроллер, когда задача загружена
        if (state.task != null &&
            _controller.text != (state.task!.description ?? '')) {
          _controller.text = state.task!.description ?? '';
          _isDescriptionEmpty = (state.task!.description ?? '').trim().isEmpty;
        }
        if (state.isUpdateSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Описание успешно сохранен'),
              backgroundColor: Colors.green,
              behavior:
                  SnackBarBehavior.floating, 
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.isError || state.task == null) {
          return Scaffold(
            appBar: AppBar(title: const Text("Ошибка")),
            body: const Center(child: Text("Не удалось загрузить задачу")),
          );
        }

        final task = state.task!;

        return Scaffold(
          appBar: AppBar(
            title: Text(
              task.title,
              style: const TextStyle(fontWeight: FontWeight.normal),
            ),
            centerTitle: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            actions: [
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () async {
                  final cubit = context.read<DetailCubit>();
                  await cubit.deleteTask(task.id);
                  if (mounted) Navigator.pop(context, null);
                },
                tooltip: 'Удалить задачу',
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Описание',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Введите описание задачи',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  maxLines: 5,
                  keyboardType: TextInputType.multiline,
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isDescriptionEmpty
                        ? null
                        : () async {
                            final cubit = context.read<DetailCubit>();
                            final success = await cubit.updateDescription(
                              task.id,
                              _controller.text.trim(),
                            );
                            if (success && mounted) {
                              final updatedTask = Todo(
                                id: task.id,
                                title: task.title,
                                description: _controller.text.trim(),
                                date: task.date,
                                isDone: task.isDone,
                              );
                              Navigator.pop(context, updatedTask);
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _isDescriptionEmpty
                          ? Colors.grey
                          : Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Сохранить изменения',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
