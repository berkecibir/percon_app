import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:percon_app/core/utils/const/app_texts.dart';
import 'package:percon_app/feat/data/model/auth/user_model.dart';
import 'package:percon_app/feat/data/repository/auth/i_user_repositiory.dart';
import 'package:percon_app/feat/data/service/auth/google_sign_in_service.dart';
import 'package:percon_app/feat/data/service/auth/i_google_sign_in_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class UserRepository implements IUserRepositiory {
  final IGoogleSignInService _googleSignInService;
  final FirebaseFirestore _firestore;

  UserRepository({
    required GoogleSignInService googleSignInService,
    required FirebaseFirestore firestore,
    auth.FirebaseAuth? firebaseAuth,
  }) : _googleSignInService = googleSignInService,
       _firestore = firestore;

  @override
  Future<UserModel?> getUserData(String uid) async {
    try {
      debugPrint('Fetching user data for UID: $uid');
      final doc = await _firestore
          .collection(AppTexts.usersCollection)
          .doc(uid)
          .get();

      debugPrint('Document exists: ${doc.exists}');
      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          debugPrint('User data: $data');
          return UserModel.fromMap(data, doc.id);
        } else {
          debugPrint('Document exists but data is null');
          return null;
        }
      } else {
        debugPrint('Document does not exist for UID: $uid');
        return null;
      }
    } catch (e) {
      debugPrint('Error fetching user data: $e');
      debugPrint('Error type: ${e.runtimeType}');
      return null;
    }
  }

  @override
  Future<UserModel?> signInWithGoogle() async {
    try {
      debugPrint('Starting Google sign in process in repository');
      final UserModel? user = await _googleSignInService.signInWithGoogle();

      debugPrint('Google sign in result: $user');

      if (user != null) {
        try {
          final DocumentSnapshot snapshot = await _firestore
              .collection(AppTexts.usersCollection)
              .doc(user.uid)
              .get();

          debugPrint('User document exists: ${snapshot.exists}');

          if (!snapshot.exists) {
            debugPrint('Creating new user document');
            await _firestore
                .collection(AppTexts.usersCollection)
                .doc(user.uid)
                .set({
                  AppTexts.fullName: user.fullName,
                  AppTexts.email: user.email,
                  AppTexts.createdAt: FieldValue.serverTimestamp(),
                });
          } else {
            debugPrint('Updating existing user document');
            await _firestore
                .collection(AppTexts.usersCollection)
                .doc(user.uid)
                .update({AppTexts.lastLogin: FieldValue.serverTimestamp()});
          }
          return user;
        } catch (firestoreError) {
          debugPrint('Error handling Firestore operations: $firestoreError');
          return null;
        }
      } else {
        debugPrint('Google sign in returned null user');
        return null;
      }
    } catch (e) {
      debugPrint('Error during Google sign in: $e');
      debugPrint('Error type: ${e.runtimeType}');
      return null;
    }
  }

  @override
  Future<void> signOut() async {
    await _googleSignInService.signOut();
  }
}
