import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// show [ErrorScreen] widget when user navigates to unknown occurs.
class ErrorScreen extends StatelessWidget {
  /// Create const instance of [ErrorScreen] widget.
  const ErrorScreen({required this.message, super.key});

  /// Error message.
  final String message;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.error,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(color: Theme.of(context).colorScheme.onError),
            ),
            const SizedBox(
              height: 20,
            ),
            TextButton(
              onPressed: () => context.go('/'),
              child: Text(
                'Go to Home Screen',
                style: Theme.of(context).textTheme.displaySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
