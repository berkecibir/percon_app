import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:percon_app/feat/data/model/auth/user_model.dart';
import 'package:percon_app/feat/data/repository/auth/i_user_repositiory.dart';
import 'package:percon_app/feat/presentation/cubit/auth/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final UserRepositiory _userRepository;
  final auth.FirebaseAuth _firebaseAuth;

  AuthCubit({
    required UserRepositiory userRepository,
    auth.FirebaseAuth? firebaseAuth,
  }) : _userRepository = userRepository,
       _firebaseAuth = firebaseAuth ?? auth.FirebaseAuth.instance,
       super(AuthInitial()) {
    _checkAuthState();
  }

  // check users auth state
  void _checkAuthState() {
    final currentUser = _firebaseAuth.currentUser;
    if (currentUser != null) {
      _getUserData(currentUser.uid);
    } else {
      emit(AuthUnauthenticated());
    }
  }

  // Sign in with Google
  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());

      final UserModel? user = await _userRepository.signInWithGoogle();

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(const AuthError(message: 'Google girişi iptal edildi'));
      }
    } catch (e) {
      emit(
        AuthError(message: 'Giriş yaparken bir hata oluştu: ${e.toString()}'),
      );
    }
  }

  // Get User data
  Future<void> _getUserData(String uid) async {
    try {
      final UserModel? user = await _userRepository.getUserData(uid);

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      emit(
        AuthError(
          message: 'Kullanıcı verileri alınırken hata oluştu: ${e.toString()}',
        ),
      );
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      emit(AuthLoading());
      await _userRepository.signOut();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(
        AuthError(message: 'Çıkış yaparken bir hata oluştu: ${e.toString()}'),
      );
    }
  }

  // Check is user authenticate
  bool get isAuthenticated => state is AuthAuthenticated;

  // Get current user
  UserModel? get currentUser {
    if (state is AuthAuthenticated) {
      return (state as AuthAuthenticated).user;
    }
    return null;
  }
}
