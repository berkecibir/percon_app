import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:percon_app/core/utils/const/app_texts.dart';

class UserModel extends Equatable {
  final String uid;
  final String fullName;
  final String email;
  final DateTime createdAt;
  final DateTime? lastLogin;

  const UserModel({
    required this.uid,
    required this.fullName,
    required this.email,
    required this.createdAt,
    this.lastLogin,
  });

  // Firebase Auth'tan gelen verilerle UserModel oluşturmak için factory
  factory UserModel.fromFirebaseUser(auth.User user) {
    return UserModel(
      uid: user.uid,
      fullName: user.displayName ?? '',
      email: user.email ?? '',
      createdAt: DateTime.now(), // İlk oluşturma tarihi
    );
  }

  // Firestore'dan gelen verilerle UserModel oluşturmak için
  factory UserModel.fromMap(Map<String, dynamic> map, String docId) {
    return UserModel(
      uid: docId,
      fullName: map[AppTexts.fullName] as String,
      email: map[AppTexts.email] as String,
      createdAt: (map[AppTexts.createdAt] as Timestamp).toDate(),
      lastLogin: (map[AppTexts.lastLogin] as Timestamp?)?.toDate(),
    );
  }

  // UserModel'i Firestore'a yazmak için Map'e dönüştürür (uid'siz)
  Map<String, dynamic> toMap() {
    return {
      AppTexts.fullName: fullName,
      AppTexts.email: email,
      AppTexts.createdAt: createdAt,
      AppTexts.lastLogin: lastLogin,
    };
  }

  @override
  List<Object?> get props => [uid, fullName, email, createdAt, lastLogin];
}
