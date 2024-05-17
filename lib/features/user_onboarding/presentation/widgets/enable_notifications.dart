import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
// import 'package:carbon_zero/features/activities/presentation/widgets/icon_button.dart';
import 'package:carbon_zero/services/local_notifications.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// will need user to enable notifications (local and push)
class EnableNotifications extends ConsumerStatefulWidget {
  /// will need user to enable notifications (local and push)
  const EnableNotifications({required this.controller, super.key});

  /// page controller
  final PageController controller;

  @override
  ConsumerState<EnableNotifications> createState() =>
      _EnableNotificationsState();
}

class _EnableNotificationsState extends ConsumerState<EnableNotifications>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext buildContext) {
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
          ElevatedButton.icon(
            icon: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 1.3,
                  child: child,
                );
              },
              child: const Icon(Icons.notifications),
            ),
            label: const Text('Enable Notifications'),
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: context.colors.primary,
              foregroundColor: context.colors.onPrimary,
            ),
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
            text: 'Go Back',
            onPressed: () {
              widget.controller.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
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
