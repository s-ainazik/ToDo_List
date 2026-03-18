import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/data/app_db.dart';
import 'package:to_do_list/add/add_cubit.dart';
import 'package:to_do_list/data/repository.dart';
import 'package:to_do_list/add/add_state.dart';
import 'package:to_do_list/add/add_vm.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => AddCubit(AddVm(Repository(AppDb()))),
      child: Scaffold(
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
                      "Успешно сохранено",
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
                  onPressed: () async {
                    final cubit = context.read<AddCubit>();
                    final task = await cubit.addTask(_controller.text);

                    if (task != null) {
                      await Future.delayed(const Duration(seconds: 1));
                      if (mounted) {
                        // ignore: use_build_context_synchronously
                        Navigator.pop(context, task);
                      }
                    }
                  },
                  child: const Text("Сохранить"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
