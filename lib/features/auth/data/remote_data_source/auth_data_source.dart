import 'dart:async';

import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
          .withUserModelConverter()
          .doc(credentials.user?.uid)
          .set(updatedUser);
      // await LocalStorage().setUser(updatedUser);
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
      // await LocalStorage().setUser(user);
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
      await _authInstance.currentUser?.updatePhotoURL(photoUrl);
      // await LocalStorage().setUser(user);
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
      // await LocalStorage().removeUserData();
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
      await _authInstance.currentUser
          ?.updateDisplayName('${updatedUser.fName} ${updatedUser.lName}');
      // await LocalStorage().setUser(updatedUser);
      return updatedUser;
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? 'Something went wrong');
    } catch (e) {
      rethrow;
    }
  }

  /// will get the current [UserModel] snapshot from the db
  Stream<UserModel?> getCurrentUserSnapshot() {
    final userStream = _db
        .collection('users')
        .withConverter<UserModel>(
          fromFirestore: (snapshot, _) => UserModel.fromJson(snapshot.data()!),
          toFirestore: (value, _) => value.toJson(),
        )
        .doc(_authInstance.currentUser?.uid)
        .snapshots()
        .map((snapshot) => snapshot.data());
    return userStream;
  }

  /// sign up with google
  Future<void> signUpWithGoogle({
    required bool isLogIn,
    required (double, double) footPrint,
  }) async {
    try {
      // Trigger the authentication flow
      final googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      final credentials = await _authInstance.signInWithCredential(credential);
      final names = credentials.user?.displayName?.split(' ');

      final user = UserModel(
        fName: names!.first,
        lName: names.last,
        email: credentials.user!.email!,
        activityIds: const [],
        communityIds: const [],
        userId: credentials.user?.uid,
        photoId: credentials.user?.photoURL,
        initialCarbonFootPrint: footPrint.$1,
        carbonFootPrintNow: footPrint.$2,
      );
      if (isLogIn) {
        await _db.collection('users').doc(credentials.user?.uid).update({
          'fName': user.fName,
          'lName': user.lName,
          'email': user.email,
          'userId': credentials.user?.uid,
          'photoId': user.photoId,
        });
      } else {
        await _db
            .collection('users')
            .withUserModelConverter()
            .doc(credentials.user?.uid)
            .set(user);
      }
    } on FirebaseAuthException catch (e) {
      throw Failure(message: e.message ?? 'Something went wrong');
    } catch (e) {
      rethrow;
    }
  }
}

/// will provide an instance of [AuthDataSource]
final authDataSourceProvider = Provider<AuthDataSource>((ref) {
  // user is not logged in yet so access is to db
  // allowed but other data sources will use the
  // dbProvider
  final db = FirebaseFirestore.instance;
  final authInstance = ref.read(authInstanceProvider);
  return AuthDataSource(db, authInstance);
});
