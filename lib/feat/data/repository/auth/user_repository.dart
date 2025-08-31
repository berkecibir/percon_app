import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/data/model/auth/user_model.dart';
import 'package:percon_app/feat/data/repository/auth/i_user_repositiory.dart';
import 'package:percon_app/feat/data/service/auth/google_sign_in_service.dart';
import 'package:percon_app/feat/data/service/auth/i_google_sign_in_service.dart';

class UserRepository implements UserRepositiory {
  final IGoogleSignInService _googleSignInService;
  final FirebaseFirestore _firestore;

  UserRepository({
    required GoogleSignInService googleSignInService,
    required FirebaseFirestore firestore,
  }) : _googleSignInService = googleSignInService,
       _firestore = firestore;

  @override
  Future<UserModel?> getUserData(String uid) async {
    final doc = await _firestore
        .collection(AppTexts.usersCollection)
        .doc(uid)
        .get();
    if (doc.exists) {
      return UserModel.fromMap(doc.data() as Map<String, dynamic>, doc.id);
    }
    return null;
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    final UserModel? user = await _googleSignInService.signInWithGoogle();

    if (user != null) {
      final DocumentSnapshot snapshot = await _firestore
          .collection(AppTexts.usersCollection)
          .doc(user.uid)
          .get();

      if (!snapshot.exists) {
        await _firestore
            .collection(AppTexts.usersCollection)
            .doc(user.uid)
            .set({
              AppTexts.fullName: user.fullName,
              AppTexts.email: user.email,
              AppTexts.createdAt: FieldValue.serverTimestamp(),
            });
      } else {
        await _firestore
            .collection(AppTexts.usersCollection)
            .doc(user.uid)
            .update({AppTexts.lastLogin: FieldValue.serverTimestamp()});
      }
    }
    return user;
  }

  @override
  Future<void> signOut() async {
    await _googleSignInService.signOut();
  }
}
