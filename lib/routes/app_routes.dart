import 'package:carbon_zero/core/error/error_screen.dart';
import 'package:carbon_zero/core/pages/shell_route.dart';
import 'package:carbon_zero/features/auth/presentation/pages/login_screen.dart';
import 'package:carbon_zero/features/auth/presentation/pages/profile_completion.dart';
import 'package:carbon_zero/features/auth/presentation/pages/profile_photo.dart';
import 'package:carbon_zero/features/auth/presentation/pages/signup_screen.dart';
import 'package:carbon_zero/features/community/presentation/pages/community.dart';
import 'package:carbon_zero/features/community/presentation/pages/community_details.dart';
import 'package:carbon_zero/features/community/presentation/pages/community_inbox.dart';
import 'package:carbon_zero/features/home/presentation/pages/home_screen.dart';
import 'package:carbon_zero/features/notification/presentation/pages/notification.dart';
import 'package:carbon_zero/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:carbon_zero/features/profile/presentation/pages/profile.dart';
import 'package:carbon_zero/features/rewards/presentation/pages/rewards_screen.dart';
import 'package:carbon_zero/features/settings/presentation/pages/settings_screen.dart';
import 'package:carbon_zero/features/splash/presentation/pages/splash_screen.dart';
import 'package:carbon_zero/features/statistics/presentation/pages/statistics_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// App routes class.
class AppRoutes {
  static final GlobalKey<NavigatorState> _rootNavigator = GlobalKey();
  static final GlobalKey<NavigatorState> _homeShellNavigator = GlobalKey();
  static final GlobalKey<NavigatorState> _statisticsShellNavigator =
      GlobalKey();
  static final GlobalKey<NavigatorState> _communityShellNavigator = GlobalKey();
  static final GlobalKey<NavigatorState> _rewardsShellNavigator = GlobalKey();
  static final GlobalKey<NavigatorState> _settingsShellNavigator = GlobalKey();

  /// GoRouter instance.
  static final router = GoRouter(
    navigatorKey: AppRoutes._rootNavigator,
    initialLocation: '/home', // change back to '/'
    redirect: (context, state) {
      return null; // add once auth is in place
    },
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
        routes: [
          GoRoute(
            path: 'sign-in',
            parentNavigatorKey: AppRoutes._rootNavigator,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: 'profile-photo',
            parentNavigatorKey: AppRoutes._rootNavigator,
            builder: (context, state) => const ProfilePhoto(),
          ),
          GoRoute(
            path: 'profile-complete',
            parentNavigatorKey: AppRoutes._rootNavigator,
            builder: (context, state) => const ProfileSetupComplete(),
          ),
        ],
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) =>
            TabShellRoute(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            navigatorKey: AppRoutes._homeShellNavigator,
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: AppRoutes._statisticsShellNavigator,
            routes: [
              GoRoute(
                path: '/statistics',
                builder: (context, state) => const StatisticsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: AppRoutes._communityShellNavigator,
            routes: [
              GoRoute(
                path: '/community',
                builder: (context, state) => const CommunityScreen(),
                routes: [
                  GoRoute(
                    path: 'details',
                    builder: (context, state) => const CommunityDetails(),
                  ),
                  GoRoute(
                    path: 'inbox', // will make it dynamic /inbox/{name}
                    builder: (context, state) => const CommunityInbox(),
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: AppRoutes._rewardsShellNavigator,
            routes: [
              GoRoute(
                path: '/rewards',
                builder: (context, state) => const RewardsScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            navigatorKey: AppRoutes._settingsShellNavigator,
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const Profile(),
      ),
      GoRoute(
        path: '/notification',
        builder: (context, state) => const NotificationScreen(),
      ),
    ],
  );
}
