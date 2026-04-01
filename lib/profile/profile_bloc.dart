import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileState {
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  ProfileState({
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return ProfileState(
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileViewModel {
  Future<void> saveProfile(int age, int height, int weight) async {
    
    await Future.delayed(const Duration(milliseconds: 500));
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileViewModel viewModel;

  ProfileCubit() : viewModel = ProfileViewModel(), super(ProfileState());

  Future<void> saveProfile(int age, int height, int weight) async {
    emit(state.copyWith(isLoading: true, isSuccess: false, errorMessage: null));
    try {
      await viewModel.saveProfile(age, height, weight);
      emit(state.copyWith(isLoading: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(
        isLoading: false,
        isSuccess: false,
        errorMessage: e.toString(),
      ));
    }
  }
}