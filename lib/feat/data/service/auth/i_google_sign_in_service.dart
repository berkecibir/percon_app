import 'package:percon_app/feat/data/model/auth/user_model.dart';

abstract class IGoogleSignInService {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
}
