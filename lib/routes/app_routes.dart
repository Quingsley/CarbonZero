import 'package:carbon_zero/core/error/error_screen.dart';
import 'package:carbon_zero/core/pages/shell_route.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/activities/presentation/pages/icons_screen.dart';
import 'package:carbon_zero/features/auth/presentation/pages/forgot_password_screen.dart';
import 'package:carbon_zero/features/auth/presentation/pages/login_screen.dart';
import 'package:carbon_zero/features/auth/presentation/pages/profile_completion.dart';
import 'package:carbon_zero/features/auth/presentation/pages/profile_photo.dart';
import 'package:carbon_zero/features/auth/presentation/pages/signup_screen.dart';
import 'package:carbon_zero/features/chat/presentation/pages/chat.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/pages/add_community.dart';
import 'package:carbon_zero/features/community/presentation/pages/admin_communities.dart';
import 'package:carbon_zero/features/community/presentation/pages/community.dart';
import 'package:carbon_zero/features/community/presentation/pages/community_details.dart';
import 'package:carbon_zero/features/home/presentation/pages/home_screen.dart';
import 'package:carbon_zero/features/notification/presentation/pages/notification.dart';
import 'package:carbon_zero/features/onboarding/presentation/pages/onboarding_screen.dart';
import 'package:carbon_zero/features/rewards/presentation/pages/rewards_screen.dart';
import 'package:carbon_zero/features/settings/presentation/pages/settings_screen.dart';
import 'package:carbon_zero/features/splash/presentation/pages/splash_screen.dart';
import 'package:carbon_zero/features/statistics/presentation/pages/statistics_screen.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/pages/carbon_footprint_results.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/pages/user_onboarding.dart';
import 'package:carbon_zero/routes/go_router_refresh_stream.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
  static final router = Provider<GoRouter>((ref) {
    final auth = ref.read(authInstanceProvider);
    final authState = ref.read(authStateChangesProvider);
    final didUserOnboard = ref.read(didUserOnBoardProvider);
    return GoRouter(
      navigatorKey: AppRoutes._rootNavigator,
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(auth.authStateChanges()),
      redirect: (context, state) {
        if (state.fullPath == '/') {
          return authState.value?.uid != null
              ? '/home'
              : didUserOnboard
                  ? '/auth'
                  : '/onboarding'; // look into this
        }

        return null;
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
        // about the app
        GoRoute(
          path: '/onboarding',
          parentNavigatorKey: AppRoutes._rootNavigator,
          builder: (context, state) => const OnBoardingScreen(),
        ),
        // collects user data
        GoRoute(
          path: '/user-onboarding',
          parentNavigatorKey: AppRoutes._rootNavigator,
          builder: (context, state) => const UserOnboarding(),
        ),
        GoRoute(
          path: '/carbon-footprint-results',
          parentNavigatorKey: AppRoutes._rootNavigator,
          builder: (context, state) => const CarbonFootPrintResults(),
        ),
        GoRoute(
          path: '/auth',
          parentNavigatorKey: AppRoutes._rootNavigator,
          builder: (context, state) => const LoginScreen(),
          routes: [
            GoRoute(
              path: 'sign-up',
              parentNavigatorKey: AppRoutes._rootNavigator,
              builder: (context, state) => const SignUpScreen(),
            ),
            GoRoute(
              path: 'profile-photo',
              parentNavigatorKey: AppRoutes._rootNavigator,
              builder: (context, state) => const ProfilePhotoScreen(),
            ),
            GoRoute(
              path: 'profile-complete',
              parentNavigatorKey: AppRoutes._rootNavigator,
              builder: (context, state) => const ProfileSetupComplete(),
            ),
            GoRoute(
              path: 'forgot-password',
              parentNavigatorKey: AppRoutes._rootNavigator,
              builder: (context, state) => const ForgotPasswordScreen(),
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
                  routes: [
                    GoRoute(
                      parentNavigatorKey: AppRoutes._rootNavigator,
                      path: 'icons',
                      builder: (context, state) => const IconSelectionScreen(),
                    ),
                  ],
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
                      builder: (context, state) => CommunityDetails(
                        community: state.extra! as CommunityModel,
                      ),
                    ),
                    GoRoute(
                      path: 'inbox',
                      parentNavigatorKey: AppRoutes._rootNavigator,
                      builder: (context, state) => CommunityInbox(
                        communityModel: state.extra! as CommunityModel,
                      ),
                    ),
                    GoRoute(
                      path: 'add-community',
                      parentNavigatorKey: AppRoutes._rootNavigator,
                      builder: (context, state) {
                        return AddCommunity(
                          community: state.extra != null
                              ? state.extra! as CommunityModel
                              : null,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'admin',
                      builder: (context, state) => const AdminCommunities(),
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
          path: '/notification',
          builder: (context, state) => const NotificationScreen(),
        ),
      ],
    );
  });
}
