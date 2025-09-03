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
  // ... existing code ...
  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google Sign In process');
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        debugPrint('Google Sign In was cancelled by user');
        return null;
      }

      debugPrint('Google user signed in: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      debugPrint('Google auth successful, getting credential');

      final auth.OAuthCredential credential =
          auth.GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken,
            idToken: googleAuth.idToken,
          );

      debugPrint('Signing in with Firebase credential');
      final auth.UserCredential userCredential = await _auth
          .signInWithCredential(credential);

      final auth.User? user = userCredential.user;

      if (user == null) {
        debugPrint('Firebase user is null');
        return null;
      }

      debugPrint('Firebase user signed in: ${user.uid}');

      final DocumentReference userDocRef = _firestore
          .collection(AppTexts.usersCollection)
          .doc(user.uid);

      debugPrint('Checking if user document exists');
      final DocumentSnapshot snapshot = await userDocRef.get();

      if (!snapshot.exists) {
        debugPrint('Creating new user document');
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
        debugPrint('Updating existing user document');
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
      debugPrint('FirebaseException code: ${e.code}');
      debugPrint('FirebaseException message: ${e.message}');
      return null;
    } on CustomException catch (e) {
      // General exception handling
      debugPrint('CustomException: ${e.toString()}');
      return null;
    } catch (e) {
      debugPrint('Unexpected error during Google Sign In: $e');
      debugPrint('Error type: ${e.runtimeType}');
      return null;
    }
  }
  // ... existing code ...

  @override
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }
}
