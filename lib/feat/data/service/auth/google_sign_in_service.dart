import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flutter/material.dart';
import 'package:percon_app/core/exception/custom_exception.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/data/model/auth/user_model.dart';
import 'package:percon_app/feat/data/service/auth/i_google_sign_in_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInService implements IGoogleSignInService {
  final auth.FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final FirebaseFirestore _firestore;

  GoogleSignInService({
    auth.FirebaseAuth? authInstance,
    GoogleSignIn? googleSignInInstance,
    FirebaseFirestore? firestoreInstance,
  }) : _auth = authInstance ?? auth.FirebaseAuth.instance,
       _googleSignIn = googleSignInInstance ?? GoogleSignIn(),
       _firestore = firestoreInstance ?? FirebaseFirestore.instance;
  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final auth.OAuthCredential credential =
          auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

      final auth.UserCredential userCredential = await _auth
          .signInWithCredential(credential);
      final auth.User? user = userCredential.user;
      if (user == null) {
        return null;
      }

      final DocumentReference userDocRef = _firestore
          .collection(AppTexts.usersCollection)
          .doc(user.uid);
      final DocumentSnapshot snapshot = await userDocRef.get();

      if (!snapshot.exists) {
        // New User - First time auth
        final newUser = UserModel(
          uid: user.uid,
          fullName: user.displayName ?? '',
          email: user.email ?? '',
          createdAt: DateTime.now(),
          lastLogin: DateTime.now(),
        );

        await userDocRef.set({
          AppTexts.fullName: newUser.fullName,
          AppTexts.email: newUser.email,
          AppTexts.createdAt: FieldValue.serverTimestamp(),
          AppTexts.lastLogin: FieldValue.serverTimestamp(),
        });

        return newUser;
      } else {
        // if user signed in before - update lastLogin
        await userDocRef.update({
          AppTexts.lastLogin: FieldValue.serverTimestamp(),
        });

        final updatedSnapshot = await userDocRef.get();
        return UserModel.fromMap(
          updatedSnapshot.data()! as Map<String, dynamic>,
          user.uid,
        );
      }
    } on FirebaseException catch (e) {
      debugPrint('${AppTexts.firebaseExceptionMsg} $e');
      return null;
    } on CustomException catch (e) {
      // General exception handling
      debugPrint('Google Sign In Error: ${e.toString()}');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
