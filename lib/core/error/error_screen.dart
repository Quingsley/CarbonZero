import 'package:flutter/material.dart';

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
        child: Text(
          message,
          style: Theme.of(context)
              .textTheme
              .headlineSmall
              ?.copyWith(color: Theme.of(context).colorScheme.onError),
        ),
      ),
    );
  }
}
