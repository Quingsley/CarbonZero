import 'package:carbon_zero/core/theme/theme.dart';

import 'package:carbon_zero/firebase_options.dart';
import 'package:carbon_zero/routes/app_routes.dart';
import 'package:carbon_zero/services/local_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalStorage().init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: CarbonZero()));
}

/// Root widget of the [CarbonZero] app.
class CarbonZero extends ConsumerWidget {
  /// Create const instance of app root widget.
  const CarbonZero({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(AppRoutes.router);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CarbonZero',
      darkTheme: darkTheme,
      theme: lightTheme,
      // themeMode: ThemeMode.dark,
      routeInformationParser: router.routeInformationParser,
      routeInformationProvider: router.routeInformationProvider,
      routerDelegate: router.routerDelegate,
    );
  }
}
