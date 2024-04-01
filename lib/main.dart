import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carbon_zero/app.dart';
import 'package:carbon_zero/core/constants/flavors.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/theme/theme.dart';
import 'package:carbon_zero/core/utils/utils.dart';
import 'package:carbon_zero/features/splash/presentation/pages/splash_screen.dart';
import 'package:carbon_zero/firebase_options.dart';
import 'package:carbon_zero/firebase_options.dev.dart' as dev;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  final storage = await SharedPreferences.getInstance();
  if (kDebugMode) {
    print('Handling a background message: ${message.messageId}');
    print('Message data: ${message.data}');
    print('Message notification: ${message.notification?.title}');
    print('Message notification: ${message.notification?.body}');
  }
  await storeNotifications(message, storage);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await preloadSVG([
    'assets/images/coin.svg',
    'assets/images/community-icon.svg',
    'assets/images/community.svg',
    'assets/images/ecology_light.svg',
    'assets/images/home.svg',
    'assets/images/hobby_activity.svg',
    'assets/images/nature_gardening.svg',
    'assets/images/rewards.svg',
    'assets/images/settings.svg',
    'assets/images/statistics.svg',
    'assets/images/storage_work.svg',
  ]);

  final env = getFlavor();
  await Firebase.initializeApp(
    options: env == Flavor.dev
        ? dev.DefaultFirebaseOptions.currentPlatform
        : DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: env == Flavor.dev
        ? AndroidProvider.debug
        : AndroidProvider.playIntegrity,
  );
  final analytics = FirebaseAnalytics.instance;
  await analytics.setAnalyticsCollectionEnabled(true);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  FlutterError.onError = (errorDetails) {
    FirebaseCrashlytics.instance.recordFlutterFatalError(errorDetails);
  };
  // Pass all uncaught asynchronous errors that aren't handled by the
  //Flutter framework to Crashlytics
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
    return true;
  };

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelGroupKey: 'activity_channel_group',
        channelKey: 'activity_channel',
        channelName: 'Activity notifications',
        channelDescription: 'Notification channel for activities',
        defaultColor: lightTheme.primaryColor,
        ledColor: lightTheme.primaryColorDark,
        onlyAlertOnce: true,
      ),
      NotificationChannel(
        channelGroupKey: 'daily_channel_group',
        channelKey: 'daily_channel',
        channelName: 'Daily notifications',
        channelDescription: 'Notification channel for daily emission',
        defaultColor: lightTheme.primaryColor,
        ledColor: lightTheme.primaryColorDark,
        onlyAlertOnce: true,
      ),
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'activity_channel_group',
        channelGroupName: 'Activity notifications',
      ),
      NotificationChannelGroup(
        channelGroupKey: 'daily_channel_group',
        channelGroupName: 'Daily notifications',
      ),
    ],
    debug: true,
  );
  runApp(const ProviderScope(child: AppStartUpWidget()));
}

/// App start up widget.
class AppStartUpWidget extends ConsumerWidget {
  /// Create const instance of app start up widget.
  const AppStartUpWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2. eagerly initialize appStartupProvider
    //(and all the providers it depends on)
    final appStartupState = ref.watch(appStartupProvider);
    final env = getFlavor();
    return appStartupState.when(
      // 3. loading state
      loading: () => MaterialApp(
        debugShowCheckedModeBanner: env == Flavor.dev,
        darkTheme: darkTheme,
        theme: lightTheme,
        home: const SplashScreen(),
      ),
      // 4. error state
      error: (e, st) => MaterialApp(
        debugShowCheckedModeBanner: env == Flavor.dev,
        darkTheme: darkTheme,
        theme: lightTheme,
        home: Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Error: $e'),
                ElevatedButton(
                  onPressed: () {
                    // 5. invalidate the appStartupProvider
                    ref
                      ..invalidate(appStartupProvider)
                      ..invalidate(didUserOnBoardProvider);
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
      ),
      // 6. success - now load the main app
      data: (_) => const CarbonZero(),
    );
  }
}
