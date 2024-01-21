import 'package:carbon_zero/core/theme/theme.dart';
import 'package:carbon_zero/routes/app_routes.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const CarbonZero());
}

/// Root widget of the [CarbonZero] app.
class CarbonZero extends StatelessWidget {
  /// Create const instance of app root widget.
  const CarbonZero({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'CarbonZero',
      darkTheme: darkTheme,
      theme: lightTheme,
      themeMode: ThemeMode.dark,
      routeInformationParser: AppRoutes.router.routeInformationParser,
      routeInformationProvider: AppRoutes.router.routeInformationProvider,
      routerDelegate: AppRoutes.router.routerDelegate,
    );
  }
}
