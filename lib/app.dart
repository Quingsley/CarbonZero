import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/theme/theme.dart';
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
    Future.delayed(Duration.zero, () async {
      await AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
        if (!isAllowed) {
          // This is just a basic example. For real apps, you must show some
          // friendly dialog box before call the request method.
          // This is very important to not harm the user experience
          // TODO: test this on android 13 and above
          showDialog<bool>(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Allow Notifications'),
                content: const Text(
                  'We need your permission to send you local notifications',
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text('No'),
                  ),
                  TextButton(
                    onPressed: () async {
                      final isPermitted = await AwesomeNotifications()
                          .requestPermissionToSendNotifications();
                      if (mounted) Navigator.of(context).pop(isPermitted);
                    },
                    child: const Text('Yes'),
                  ),
                ],
              );
            },
          );
        }
      });
      // Only after at least the action method is set,
      //the notification events are delivered
      final isSet = await AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
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
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
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
