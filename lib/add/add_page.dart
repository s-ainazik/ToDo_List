import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/add/add_bloc.dart';
import 'package:to_do_list/data/app_repository.dart';
import 'package:to_do_list/database/database_instance.dart';

class AddPage extends StatelessWidget {
  const AddPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final repo = AppRepositoryImpl(appDatabase);
        final viewModel = AddViewModel(repo);
        return AddCubit(viewModel);
      },
      child: const _AddPageContent(),
    );
  }
}

class _AddPageContent extends StatefulWidget {
  const _AddPageContent();

  @override
  State<_AddPageContent> createState() => _AddPageContentState();
}

class _AddPageContentState extends State<_AddPageContent> {
  late final TextEditingController _controller;
  bool _isTitleEmpty = true;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller.addListener(_onTitleChanged);
  }

  @override
  void dispose() {
    _controller.removeListener(_onTitleChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTitleChanged() {
    final isEmpty = _controller.text.trim().isEmpty;
    if (isEmpty != _isTitleEmpty) {
      setState(() => _isTitleEmpty = isEmpty);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Новая задача"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _controller,
              decoration: InputDecoration(
                hintText: 'Введите задачу',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 8),
            BlocBuilder<AddCubit, AddState>(
              builder: (context, state) {
                if (state.isEmpty) {
                  return const Text(
                    "Введите задачу!",
                    style: TextStyle(color: Colors.red),
                  );
                }
                if (state.isSuccess) {
                  return const Text(
                    "Успешно сохранено!",
                    style: TextStyle(color: Colors.green),
                  );
                }
                return const SizedBox();
              },
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isTitleEmpty
                    ? null
                    : () async {
                        final cubit = context.read<AddCubit>();
                        await cubit.addTask(_controller.text);
                        await Future.delayed(const Duration(seconds: 1));
                        if (mounted) Navigator.pop(context);
                      },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _isTitleEmpty ? Colors.grey : Colors.blue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text("Сохранить"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
