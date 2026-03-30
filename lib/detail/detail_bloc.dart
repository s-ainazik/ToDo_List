import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/data/app_database.dart';
import 'package:to_do_list/data/app_repository.dart';
import 'package:drift/drift.dart' as drift;

class DetailState {
  final Todo? task;
  final bool isLoading;
  final bool isError;
  final bool isUpdating;
  final bool isUpdateSuccess;

  const DetailState({
    this.task,
    this.isLoading = false,
    this.isError = false,
    this.isUpdating = false,
    this.isUpdateSuccess = false,
  });

  factory DetailState.initial() => const DetailState();

  DetailState copyWith({
    Todo? task,
    bool? isLoading,
    bool? isError,
    bool? isUpdating,
    bool? isUpdateSuccess,
  }) {
    return DetailState(
      task: task ?? this.task,
      isLoading: isLoading ?? this.isLoading,
      isError: isError ?? this.isError,
      isUpdating: isUpdating ?? this.isUpdating,
      isUpdateSuccess: isUpdateSuccess ?? this.isUpdateSuccess,
    );
  }
}

class DetailViewModel {
  final AppRepository repo;

  DetailViewModel(this.repo);

  Future<Todo?> loadTask(int id) => repo.getTaskById(id);

  Future<void> updateDescription(int id, String newDescription) async {
    final companion = TodosCompanion(
      description: drift.Value(newDescription),
    );
    await repo.updateTask(id, companion);
  }

  Future<void> deleteTask(int id) async {
    await repo.deleteTask(id);
  }
}

class DetailCubit extends Cubit<DetailState> {
  final DetailViewModel viewModel;

  DetailCubit(this.viewModel) : super(DetailState.initial());

  Future<void> loadTask(int id) async {
    emit(state.copyWith(isLoading: true, isError: false));
    try {
      final task = await viewModel.loadTask(id);
      if (task == null) {
        emit(state.copyWith(isError: true, isLoading: false));
      } else {
        emit(state.copyWith(task: task, isLoading: false));
      }
    } catch (e) {
      emit(state.copyWith(isError: true, isLoading: false));
    }
  }

  Future<bool> updateDescription(int id, String newDescription) async {
    if (newDescription.trim().isEmpty) return false;
    emit(state.copyWith(isUpdating: true, isUpdateSuccess: false));
    try {
      await viewModel.updateDescription(id, newDescription);
      final updatedTask = state.task?.copyWith(description: drift.Value(newDescription));
      emit(state.copyWith(
        task: updatedTask,
        isUpdating: false,
        isUpdateSuccess: true,
      ));
      return true;
    } catch (e) {
      emit(state.copyWith(isUpdating: false, isUpdateSuccess: false, isError: true));
      return false;
    }
  }

  Future<void> deleteTask(int id) async {
    await viewModel.deleteTask(id);
  }
}