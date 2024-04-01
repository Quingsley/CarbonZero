import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/icon_button.dart';
import 'package:carbon_zero/services/local_notifications.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// will need user to enable notifications (local and push)
class EnableNotifications extends ConsumerWidget {
  /// will need user to enable notifications (local and push)
  const EnableNotifications({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ntfService = ref.watch(notificationsProvider);
    final isLoading = ntfService is AsyncLoading;
    final pushToken = ref.watch(pushTokenProvider);
    return FormLayout(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(
            height: 120,
          ),
          Text(
            '''
    CarbonZero would like to send you notifications to help you stay on track with your carbon footprint, goals, community updates and challenges.
        ''',
            textAlign: TextAlign.center,
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(
            height: 20,
          ),
          KIconButton(
            icon: Icons.notifications,
            label: 'Enable Notifications',
            onPressed: isLoading
                ? null
                : () async {
                    await ref
                        .read(notificationsProvider.notifier)
                        .requestPermission();
                    await NotificationController.requestForPermission();
                  },
          ),
          const Spacer(),
          PrimaryButton(
            text: 'Finish',
            isLoading: isLoading,
            onPressed: isLoading || pushToken == null
                ? null
                : () {
                    context.go('/carbon-footprint-results');
                  },
          ),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
