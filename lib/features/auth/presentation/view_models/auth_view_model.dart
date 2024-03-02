import 'dart:async';

import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/constants/utils.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/feedback_model.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/view_models/carbon_foot_print_results_view_model.dart';
import 'package:carbon_zero/routes/app_routes.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [AuthViewModel] class is a view model for authentication
class AuthViewModel extends AsyncNotifier<void> {
  /// sign up method called by the view
  /// to sign up a user
  Future<void> signUp(String password, UserModel user) async {
    final repo = ref.read(authRepositoryProvider);

    final token = ref.read(pushTokenProvider);
    final (footPrint, currentFootPrint, month) = _getFootPrintData();

    final updatedUser = user.copyWith(
      initialCarbonFootPrint: footPrint,
      carbonFootPrintNow: currentFootPrint,
      pushTokens: [token!],
      totalCarbonPoints: _totalPoints(),
      monthlyFootPrintData: {
        month: currentFootPrint,
      },
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repo.signUp(updatedUser, password),
    );
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

  /// google sign in method
  Future<void> signInWithGoogle({required bool isLogin}) async {
    final repo = ref.read(authRepositoryProvider);
    final token = ref.read(pushTokenProvider);
    final footPrints = _getFootPrintData();
    final router = ref.read(AppRoutes.router);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () async {
        await repo.sigInInWithGoogle(
          isLogin: isLogin,
          footPrint: footPrints,
          token: token,
          totalPoints: _totalPoints(),
        );
        router.go('/home');
      },
    );
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

  /// returns the current foot print of a user and the footprint
  /// for the last 12 months
  (double, double, String) _getFootPrintData() {
    final carbonVm = ref.read(carbonFootPrintViewModelProvider);
    final footPrint = carbonVm.value;
    final daysElapsed = getNumberOfDaysElapsed(DateTime.now().year);
    final totalDays = getNumberOfDaysInYear(DateTime.now().year);
    final currentMonth = DateTime.now().month;
    final month = getMonth[currentMonth]!;
    final currentFootPrint = (daysElapsed / totalDays) * (footPrint ?? 0);
    return (footPrint ?? 0, currentFootPrint, month);
  }

  int _totalPoints() {
    final (_, value, _) = _getFootPrintData();
    if (value < 2700) {
      return 20;
    } else if (value >= 2700 && value <= 7250) {
      return 14;
    } else if (value >= 7250 && value <= 10000) {
      return 4;
    } else {
      return 2;
    }
  }

  /// collect feedback method
  Future<void> collectFeedback(FeedBackModel feedback) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(authRepositoryProvider).collectUserFeedback(feedback),
    );
  }

  @override
  FutureOr<void> build() async {
    // await init();
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

/// [isGoogleButtonProvider] provider
final isGoogleButtonProvider = StateProvider<bool>((ref) {
  return false;
});
