import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/data/app_database.dart';
import 'package:to_do_list/data/app_repository.dart';

class HomeState {
  final List<Todo> items;
  final bool isError;

  const HomeState({required this.items, required this.isError});

  factory HomeState.initial() => const HomeState(items: [], isError: false);

  HomeState copyWith({List<Todo>? items, bool? isError}) {
    return HomeState(
      items: items ?? this.items,
      isError: isError ?? this.isError,
    );
  }
}

class HomeViewModel {
  final AppRepository repo;
  HomeViewModel(this.repo);

  Future<List<Todo>> fetchList() => repo.getList();
}

class HomeCubit extends Cubit<HomeState> {
  final HomeViewModel viewModel;

  HomeCubit(this.viewModel) : super(HomeState.initial());

  Future<void> fetchList() async {
    try {
      final items = await viewModel.fetchList();
      emit(state.copyWith(items: items, isError: false));
    } catch (e) {
      emit(state.copyWith(items: [], isError: true));
    }
  }

  Future<void> addTask(TodosCompanion companion) async {
    await viewModel.repo.addTask(companion);
    await fetchList();
  }

  Future<void> updateTask(int id, TodosCompanion companion) async {
    await viewModel.repo.updateTask(id, companion);
    await fetchList();
  }

  Future<void> deleteTask(int id) async {
    await viewModel.repo.deleteTask(id);
    await fetchList();
  }
}