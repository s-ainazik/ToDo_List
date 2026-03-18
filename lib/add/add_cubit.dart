import 'package:to_do_list/add/add_state.dart';
import 'package:to_do_list/add/add_vm.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_list/add/todo.dart';

class AddCubit extends Cubit<AddState> {
  final AddVm viewModel;

  AddCubit(this.viewModel) : super(AddState(isEmpty: false, isSuccess: false));

  Future<Todo?> addTask(String title) async {
    if (title.trim().isEmpty) {
      emit(AddState(isEmpty: true, isSuccess: false));
      return null;
    }

    final task = await viewModel.addTask(title);
    emit(AddState(isEmpty: false, isSuccess: true));
    return task;
  }
}