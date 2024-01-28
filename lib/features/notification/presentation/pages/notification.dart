import 'package:flutter/material.dart';

/// will contain user notifications
class NotificationScreen extends StatelessWidget {
  /// constructor call
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: const Center(
        child: Text('Notifications'),
      ),
    );
  }
}
