import 'package:percon_app/feat/data/model/auth/user_model.dart';

abstract class UserRepositiory {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getUserData(String uid);
}
