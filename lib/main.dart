import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:carbon_zero/app.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/theme/theme.dart';
import 'package:carbon_zero/features/splash/presentation/pages/splash_screen.dart';
import 'package:carbon_zero/firebase_options.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );
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
  await AwesomeNotifications().initialize(
    // set the icon to null if you want to use the default app icon
    null,
    [
      NotificationChannel(
        channelGroupKey: 'basic_channel_group',
        channelKey: 'basic_channel',
        channelName: 'Basic notifications',
        channelDescription: 'Notification channel for basic tests',
        defaultColor: lightTheme.primaryColor,
        ledColor: lightTheme.primaryColorDark,
        onlyAlertOnce: true,
      ),
    ],
    // Channel groups are only visual and are not required
    channelGroups: [
      NotificationChannelGroup(
        channelGroupKey: 'basic_channel_group',
        channelGroupName: 'Basic group',
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
    return appStartupState.when(
      // 3. loading state
      loading: () => MaterialApp(
        darkTheme: darkTheme,
        theme: lightTheme,
        home: const SplashScreen(),
      ),
      // 4. error state
      error: (e, st) => MaterialApp(
        darkTheme: darkTheme,
        theme: lightTheme,
        home: Scaffold(
          body: Center(
            child: Column(
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
