import 'package:carbon_zero/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will contain user notifications
class NotificationScreen extends ConsumerStatefulWidget {
  /// constructor call
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {


  @override
  Widget build(BuildContext context) {
    final notifications = ref.watch(notificationMessagesProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: notifications.isEmpty
          ? const Center(
              child: Text('No notifications yet'),
            )
          : ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return ListTile(
                  title: Text(notification.notification!.title!),
                  subtitle: Text(notification.notification!.body!),
                );
              },
            ),
    );
  }
}
