import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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
                final ntfData = notification.data['type'] as String;
                final ntfType = ntfData == NotificationTypes.chat.name
                    ? NotificationTypes.chat
                    : ntfData == NotificationTypes.tip.name
                        ? NotificationTypes.tip
                        : NotificationTypes.communityChallenge;
                return ListTile(
                  key: ValueKey(notification.messageId),
                  leading: Icon(
                    ntfType == NotificationTypes.chat
                        ? Icons.chat
                        : ntfType == NotificationTypes.tip
                            ? Icons.lightbulb
                            : Icons.people,
                    color: context.colors.primary,
                  ),
                  title: Text(notification.notification!.title!),
                  subtitle: Text(notification.notification!.body!),
                  trailing: Text(
                    DateFormat('dd/MM/yyyy').format(notification.sentTime!),
                  ),
                );
              },
            ),
    );
  }
}
