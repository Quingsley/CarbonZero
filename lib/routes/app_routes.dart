import 'package:carbon_zero/core/error/error_screen.dart';
import 'package:carbon_zero/features/auth/pages/auth_screen.dart';
import 'package:carbon_zero/features/onboarding/pages/onboarding_screen.dart';
import 'package:carbon_zero/features/splash/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App routes class.
class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigator = GlobalKey();

  /// GoRouter instance.
  static final router = GoRouter(
    navigatorKey: AppRoutes._rootNavigator,
    initialLocation: '/',
    debugLogDiagnostics: true,
    errorBuilder: (context, state) => ErrorScreen(
      message: state.error?.message ?? state.error.toString(),
    ),
    routes: [
      GoRoute(
        path: '/',
        parentNavigatorKey: AppRoutes._rootNavigator,
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        parentNavigatorKey: AppRoutes._rootNavigator,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: '/auth',
        parentNavigatorKey: AppRoutes._rootNavigator,
        builder: (context, state) => const AuthScreen(),
      ),
    ],
  );
}
