import 'package:percon_app/feat/data/model/auth/user_model.dart';

abstract class IUserRepositiory {
  Future<UserModel?> signInWithGoogle();
  Future<void> signOut();
  Future<UserModel?> getUserData(String uid);
}
