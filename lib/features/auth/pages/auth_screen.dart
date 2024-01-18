import 'package:flutter/material.dart';

/// simple [AuthScreen] widget.
class AuthScreen extends StatefulWidget {
  /// create const instance of [AuthScreen] widget.
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          'AuthScreen',
        ),
      ),
    );
  }
}
