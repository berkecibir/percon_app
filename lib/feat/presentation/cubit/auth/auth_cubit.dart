import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

  Future<void> signInWithGoogle() async {
    try {
      emit(AuthLoading());

      debugPrint('Starting Google sign in process...');

      final UserModel? user = await _userRepository.signInWithGoogle();

      debugPrint('Sign in result: $user');

      if (user != null) {
        debugPrint('User signed in successfully, UID: ${user.uid}');
        emit(AuthAuthenticated(user: user));
      } else {
        debugPrint('Google sign in was cancelled or failed');
        emit(const AuthError(message: 'Google girişi iptal edildi'));
      }
    } on auth.FirebaseAuthException catch (e) {
      String errorMessage = 'Giriş yaparken bir hata oluştu';
      if (e.code == 'account-exists-with-different-credential') {
        errorMessage = 'Bu e-posta ile başka bir hesap zaten var';
      } else if (e.code == 'invalid-credential') {
        errorMessage = 'Geçersiz kimlik bilgisi';
      } else if (e.code == 'operation-not-allowed') {
        errorMessage = 'Google ile giriş izni verilmemiş';
      } else if (e.code == 'user-disabled') {
        errorMessage = 'Kullanıcı hesabı devre dışı bırakılmış';
      } else if (e.code == 'user-not-found') {
        errorMessage = 'Kullanıcı bulunamadı';
      } else if (e.code == 'wrong-password') {
        errorMessage = 'Yanlış şifre';
      } else if (e.code == 'too-many-requests') {
        errorMessage = 'Çok fazla istek gönderildi, daha sonra tekrar deneyin';
      }
      debugPrint('FirebaseAuthException: ${e.code} - ${e.message}');
      emit(AuthError(message: errorMessage));
    } catch (e) {
      debugPrint('General exception during sign in: $e');
      debugPrint('Exception type: ${e.runtimeType}');

      // Handle other exceptions including PlatformException
      String errorMessage = 'Giriş yaparken bir hata oluştu: ${e.toString()}';
      // Check if it's a PlatformException and handle specific cases
      if (e is PlatformException) {
        if (e.code == 'sign_in_failed') {
          if (e.message?.contains('DEVELOPER_ERROR') == true) {
            errorMessage =
                'Geliştirici hatası: SHA sertifikası veya Google Services dosyası eksik olabilir';
          } else if (e.message?.contains('INVALID_ACCOUNT') == true) {
            errorMessage = 'Geçersiz hesap';
          } else {
            errorMessage = 'Google ile giriş yapılamadı: ${e.message ?? ''}';
          }
        }
      }
      emit(AuthError(message: errorMessage));
    }
  }

  // Get User data
  Future<void> _getUserData(String uid) async {
    try {
      debugPrint('Getting user data for UID: $uid');
      final UserModel? user = await _userRepository.getUserData(uid);

      debugPrint('User data retrieved: $user');

      if (user != null) {
        emit(AuthAuthenticated(user: user));
      } else {
        debugPrint('User data is null for UID: $uid');
        emit(AuthUnauthenticated());
      }
    } catch (e) {
      debugPrint('Error getting user data: $e');
      debugPrint('Error type: ${e.runtimeType}');
      debugPrint('Stack trace: ${e.toString()}');

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
