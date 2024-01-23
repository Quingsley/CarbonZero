import 'package:carbon_zero/services/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// simple [SplashScreen] widget.
class SplashScreen extends StatelessWidget {
  /// Create const instance of [SplashScreen] widget.
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () async {
      await LocalStorage().readOnboarding();
      if (LocalStorage.didUserOnboard) {
        if (context.mounted) context.go('/auth');
      } else {
        if (context.mounted) context.go('/onboarding');
      }
    });
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.primary,
      body: Center(
        child: Text(
          'CarbonZero',
          style: Theme.of(context)
              .textTheme
              .displaySmall
              ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
        ),
      ),
    );
  }
}
