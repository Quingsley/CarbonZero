import 'dart:io';

import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AuthDataSource] class is a remote data source for authentication
class AuthDataSource {
  /// const constructor
  AuthDataSource(this._db, this._authInstance, this._storage);

  /// instance of firebase auth
  final FirebaseAuth _authInstance;
  final FirebaseFirestore _db;
  final FirebaseStorage _storage;

  /// sign up method
  Future<UserModel> signUp(String password, UserModel user) async {
    try {
      final credentials = await _authInstance.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      final updatedUser = user.copyWith(userId: credentials.user?.uid);

      /// references the document Id in the users collection
      await _db
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          )
          .doc(credentials.user?.uid)
          .set(updatedUser);

      return updatedUser;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        throw Failure(message: 'The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw Failure(message: 'The account already exists for that email.');
      }
      throw Failure(message: 'something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  /// sign in method
  Future<UserModel> signIn(String email, String password) async {
    try {
      final credentials = await _authInstance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user =
          await _db.collection('users').doc(credentials.user!.uid).get();
      return UserModel.fromJson(user.data()!);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Failure(message: 'No user found for that email.');
      } else if (e.code == 'wrong-password') {
        throw Failure(message: 'Wrong password provided for that user.');
      }
      throw Failure(message: e.message ?? 'something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  /// upload profile image
  Future<UserModel> uploadProfileImage(String path, String userId) async {
    final file = File(path);
    final storageRef = _storage.ref();
    final UploadTask? uploadTask;
    try {
      final name = '$userId.${path.split('.').last}';
      final profileRef = storageRef.child('profile_images/$name');
      uploadTask = profileRef.putFile(file.absolute);
      final snapshot = await uploadTask.whenComplete(() {});
      final downloadUrl = await snapshot.ref.getDownloadURL();
      await _db
          .collection('users')
          .doc(userId)
          .update({'photoId': downloadUrl});
      final user = await _db.collection('users').doc(userId).get();
      return UserModel.fromJson(user.data()!);
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? 'something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  /// forget Password
  Future<UserModel?> forgotPassword(String email) async {
    try {
      await _authInstance.sendPasswordResetEmail(
        email: email,
        // actionCodeSettings: ActionCodeSettings(
        //   url: 'https://carbonzero.page.link/forgetPassword',
        //   handleCodeInApp: true,
        //   androidPackageName: 'com.quingsley.carbon_zero',
        //   androidInstallApp: true,
        //   androidMinimumVersion: '6',
        // ),
      );
      return null;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Failure(message: 'No user found for that email.');
      }
      throw Failure(message: e.message ?? 'something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  /// sign out method
  Future<UserModel?> signOut() async {
    try {
      await _authInstance.signOut();
      return null;
    } on FirebaseAuthException catch (e) {
      throw Failure(message: e.message ?? 'something went wrong');
    } catch (e) {
      rethrow;
    }
  }
}

/// will provide an instance of [AuthDataSource]
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final db = ref.read(dbProvider);
  final authInstance = ref.read(authInstanceProvider);
  final storageInstance = ref.read(storageProvider);
  return AuthDataSource(db, authInstance, storageInstance);
});
