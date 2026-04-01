import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/profile/profile_bloc.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const _ProfileContent(),
    );
  }
}

class _ProfileContent extends StatefulWidget {
  const _ProfileContent();

  @override
  State<_ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends State<_ProfileContent> {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  @override
  void dispose() {
    _ageController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Анкета'),
        centerTitle: true,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state.errorMessage != null) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.red,
              ),
            );
          }
          if (state.isSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Данные сохранены'),
                backgroundColor: Colors.green,
              ),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _ageController,
                  decoration: const InputDecoration(
                    labelText: 'Возраст (лет)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 5, 100, 'Возраст'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _heightController,
                  decoration: const InputDecoration(
                    labelText: 'Рост (см)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 50, 250, 'Рост'),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _weightController,
                  decoration: const InputDecoration(
                    labelText: 'Вес (кг)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) => _validateNumber(value, 10, 500, 'Вес'),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                  ),
                  child: const Text('Сохранить'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String? _validateNumber(String? value, double min, double max, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return 'Введите $fieldName';
    }
    try {
      final number = double.parse(value);
      if (number < min) {
        throw Exception('$fieldName не может быть меньше $min');
      }
      if (number > max) {
        throw Exception('$fieldName не может быть больше $max');
      }
    } catch (e) {
      return e.toString();
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final age = int.parse(_ageController.text);
      final height = int.parse(_heightController.text);
      final weight = int.parse(_weightController.text);
      context.read<ProfileCubit>().saveProfile(age, height, weight);
    }
  }
}