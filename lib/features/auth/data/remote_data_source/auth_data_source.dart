import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/services/local_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AuthDataSource] class is a remote data source for authentication
class AuthDataSource {
  /// const constructor
  AuthDataSource(
    this._db,
    this._authInstance,
  );

  /// instance of firebase auth
  final FirebaseAuth _authInstance;
  final FirebaseFirestore _db;

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
      await LocalStorage().setUser(updatedUser);
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
      final doc =
          await _db.collection('users').doc(credentials.user!.uid).get();
      final user = UserModel.fromJson(doc.data()!);
      await LocalStorage().setUser(user);
      return user;
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
  Future<UserModel> uploadProfileImage(String photoUrl, String userId) async {
    try {
      await _db.collection('users').doc(userId).update({'photoId': photoUrl});
      final doc = await _db.collection('users').doc(userId).get();
      final user = UserModel.fromJson(doc.data()!);
      await LocalStorage().setUser(user);
      return user;
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
      await LocalStorage().removeUserData();
      return null;
    } on FirebaseAuthException catch (e) {
      throw Failure(message: e.message ?? 'something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  /// updates user details
  Future<UserModel> updateUserDetails(UserModel user) async {
    try {
      await _db
          .collection('users')
          .withConverter<UserModel>(
            fromFirestore: (snapshot, _) =>
                UserModel.fromJson(snapshot.data()!),
            toFirestore: (value, _) => value.toJson(),
          )
          .doc(user.userId)
          .update(user.toJson());
      final json = await _db.collection('users').doc(user.userId).get();
      final updatedUser = UserModel.fromJson(json.data()!);
      await LocalStorage().setUser(updatedUser);
      return updatedUser;
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? 'Something went wrong');
    } catch (e) {
      rethrow;
    }
  }
}

/// will provide an instance of [AuthDataSource]
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  final db = ref.read(dbProvider);
  final authInstance = ref.read(authInstanceProvider);
  return AuthDataSource(db, authInstance);
});
