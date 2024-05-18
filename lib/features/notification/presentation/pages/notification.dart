import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/widgets/expansion_tile_card.dart';
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
                // don't want it to throw null when testing using firebase
                final ntfData = (notification.data['type']) ?? 'chat';
                final ntfType = ntfData == NotificationTypes.chat.name
                    ? NotificationTypes.chat
                    : ntfData == NotificationTypes.tip.name
                        ? NotificationTypes.tip
                        : NotificationTypes.communityChallenge;
                return CustomExpansionTile(
                  key: ValueKey(notification.messageId),
                  icon: ntfType == NotificationTypes.chat
                      ? Icons.chat
                      : ntfType == NotificationTypes.tip
                          ? Icons.lightbulb
                          : Icons.people,
                  title: notification.notification!.title!,
                  subtitle: notification.notification!.body!,
                  trailing:
                      DateFormat('dd/MM/yyyy').format(notification.sentTime!),
                );
              },
            ),
    );
  }
}
