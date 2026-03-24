import 'package:flutter/material.dart';
import 'package:to_do_list/add/todo.dart';

class TaskDetailPage extends StatefulWidget {
  final Todo task;

  const TaskDetailPage({
    super.key,
    required this.task,
  });

  @override
  State<TaskDetailPage> createState() => _TaskDetailPageState();
}

class _TaskDetailPageState extends State<TaskDetailPage> {
  late TextEditingController _descriptionController;
  bool _isDescriptionEmpty = true;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.task.description);
    _isDescriptionEmpty = widget.task.description.trim().isEmpty;
    _descriptionController.addListener(_onDescriptionChanged);
  }

  @override
  void dispose() {
    _descriptionController.removeListener(_onDescriptionChanged);
    _descriptionController.dispose();
    super.dispose();
  }

  void _onDescriptionChanged() {
    final isEmpty = _descriptionController.text.trim().isEmpty;
    if (isEmpty != _isDescriptionEmpty) {
      setState(() {
        _isDescriptionEmpty = isEmpty;
      });
    }
  }

  Future<void> _saveChanges() async {
    if (_isDescriptionEmpty) return;

    final updatedTask = Todo(
      id: widget.task.id,
      title: widget.task.title,
      description: _descriptionController.text.trim(),
      date: widget.task.date,
      isDone: widget.task.isDone,
    );

    if (mounted) {
      Navigator.pop(context, updatedTask);
    }
  }

  Future<void> _deleteTask() async {
    // Возвращаем специальное значение, указывающее на удаление
    // (например, объект с id для удаления или null)
    if (mounted) {
      Navigator.pop(context, null);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.task.title,
          style: const TextStyle(fontWeight: FontWeight.normal),
        ),
        centerTitle: true,
        backgroundColor: theme.scaffoldBackgroundColor,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: _deleteTask,
            tooltip: 'Удалить задачу',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Описание',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                hintText: 'Введите описание задачи',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isDescriptionEmpty ? null : _saveChanges,
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isDescriptionEmpty ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text('Сохранить изменения', style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}