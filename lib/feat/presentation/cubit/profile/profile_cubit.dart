import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percon_app/feat/data/repository/auth/i_user_repositiory.dart';
import 'package:percon_app/feat/presentation/cubit/profile/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepositiory _userRepository;

  ProfileCubit({required UserRepositiory userRepository})
    : _userRepository = userRepository,
      super(ProfileState.initial());

  Future<void> loadUserProfile(String uid) async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final user = await _userRepository.getUserData(uid);
      emit(state.copyWith(user: user, isLoading: false));
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
