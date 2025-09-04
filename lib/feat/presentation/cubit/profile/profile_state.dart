import 'package:equatable/equatable.dart';
import 'package:percon_app/feat/data/model/auth/user_model.dart';

class ProfileState extends Equatable {
  final UserModel? user;
  final bool isLoading;
  final String? error;

  const ProfileState({this.user, this.isLoading = false, this.error});

  factory ProfileState.initial() {
    return const ProfileState();
  }

  ProfileState copyWith({UserModel? user, bool? isLoading, String? error}) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [user, isLoading, error];
}
