import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/theme/theme.dart';
import 'package:carbon_zero/features/splash/presentation/pages/splash_screen.dart';

import 'package:carbon_zero/firebase_options.dart';
import 'package:carbon_zero/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: AppStartUpWidget()));
}

/// Root widget of the [CarbonZero] app.
class CarbonZero extends ConsumerWidget {
  /// Create const instance of app root widget.
  const CarbonZero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
