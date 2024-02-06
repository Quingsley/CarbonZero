import 'dart:async';

import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:carbon_zero/services/local_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AuthViewModel] class is a view model for authentication
class AuthViewModel extends AsyncNotifier<void> {
  /// initializes the user
  Future<void> init() async {
    state = await AsyncValue.guard(() => LocalStorage().getUser());
  }

  /// sign up method called by the view
  /// to sign up a user
  Future<void> signUp(String password, UserModel user) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.signUp(user, password));
  }

  /// sign in method called by the view
  Future<void> signIn(String email, String password) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.signIn(email, password));
  }

  /// upload profile image method called by the view
  Future<void> uploadProfileImage(String path) async {
    final repo = ref.read(authRepositoryProvider);
    final user = ref.read(authInstanceProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repo.uploadProfileImage(path, user.currentUser!.uid),
    );
  }

  /// forget password method
  Future<void> forgotPassword(String email) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.forgotPassword(email));
  }

  /// sign out method called by the view
  Future<void> signOut() async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(repo.signOut);
  }

  /// update user details
  Future<void> updateUser(UserModel user) async {
    final repo = ref.read(authRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.updateUser(user));
  }

  @override
  FutureOr<void> build() async {
    await init();
  }
}

/// will provide an instance of [AuthViewModel]
final authViewModelProvider =
    AsyncNotifierProvider<AuthViewModel, void>(AuthViewModel.new);

/// will get the current user snapshot from the db
final userStreamProvider = StreamProvider.autoDispose((ref) {
  final repo = ref.read(authRepositoryProvider);
  return repo.getCurrentUserSnapshot();
});
