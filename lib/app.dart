import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carbon_zero/core/constants/flavors.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/theme/theme.dart';
import 'package:carbon_zero/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/routes/app_routes.dart';
import 'package:carbon_zero/services/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Root widget of the [CarbonZero] app.
class CarbonZero extends ConsumerStatefulWidget {
  /// Create const instance of app root widget.
  const CarbonZero({super.key});

  @override
  ConsumerState<CarbonZero> createState() => _CarbonZeroState();
}

class _CarbonZeroState extends ConsumerState<CarbonZero> {
  @override
  void initState() {
    final messagingInstance = ref.read(firebaseMessagingProvider);
    messagingInstance.onTokenRefresh.listen((token) async {
      final user = ref.read(userStreamProvider);
      debugPrint('updated token------------- $token---------');
      if (user.value != null) {
        final isPresent = user.value!.pushTokens.contains(token);
        if (!isPresent) {
          await ref
              .read(authRepositoryProvider)
              .updatePushToken(token, user.value!.userId!);
        }
      }
    });
    Future.delayed(Duration.zero, () async {
      // Only after at least the action method is set,
      //the notification events are delivered
      final isSet = await AwesomeNotifications().setListeners(
        onActionReceivedMethod: (receivedAction) async {
          await NotificationController.onActionReceivedMethod(
            receivedAction,
            context,
          );
        },
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod,
      );
      debugPrint(
        'isSET-----$isSet',
      );
    });

    super.initState();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final router = ref.watch(AppRoutes.router);
    final isDarkMode = ref.watch(isDarkModeStateProvider);
    final env = getFlavor();
    return MaterialApp.router(
      debugShowCheckedModeBanner: env == Flavor.dev,
      title: 'CarbonZero',
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}
