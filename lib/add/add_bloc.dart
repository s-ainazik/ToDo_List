import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/data/app_database.dart';
import 'package:to_do_list/data/app_repository.dart';

class AddState {
  final bool isEmpty;
  final bool isSuccess;

  const AddState({required this.isEmpty, required this.isSuccess});

  factory AddState.initial() => const AddState(isEmpty: false, isSuccess: false);

  AddState copyWith({bool? isEmpty, bool? isSuccess}) {
    return AddState(
      isEmpty: isEmpty ?? this.isEmpty,
      isSuccess: isSuccess ?? this.isSuccess,
    );
  }
}

class AddViewModel {
  final AppRepository repo;
  AddViewModel(this.repo);

  Future<void> addTask(String title) async {
    final companion = TodosCompanion.insert(
      title: title,
      date: DateTime.now().toIso8601String(),
    );
    await repo.addTask(companion);
  }
}

class AddCubit extends Cubit<AddState> {
  final AddViewModel viewModel;

  AddCubit(this.viewModel) : super(AddState.initial());

  Future<void> addTask(String title) async {
    if (title.trim().isEmpty) {
      emit(state.copyWith(isEmpty: true, isSuccess: false));
      return;
    }

    try {
      await viewModel.addTask(title);
      emit(state.copyWith(isEmpty: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isEmpty: false, isSuccess: false));
    }
  }

  void reset() {
    emit(AddState.initial());
  }
}