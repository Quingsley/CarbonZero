import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [NtfTile] a tile to enable or disable notifications
class NtfTile extends ConsumerWidget {
  /// const constructor
  const NtfTile({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);
    ref.listen(notificationsProvider, (previous, next) {
      next.whenOrNull(
        loading: () {
          //TODO: FIX THIS ALSO ALL LOGIN AND SIGNUP LOADING DIALOGS
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Requesting permission...'),
            ),
          );
        },
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(error is Failure ? error.message : error.toString()),
            ),
          );
        },
      );
    });
    return SwitchListTile(
      title: Text(
        'Enable Notifications',
        style: context.textTheme.labelSmall,
      ),
      value: user.value != null && user.value!.pushTokens.isNotEmpty,
      onChanged: (value) async {
        if (value) {
          await ref.read(notificationsProvider.notifier).requestPermission();
        }
      },
      onFocusChange: (val) async {
        if (val) {
          await ref.read(notificationsProvider.notifier).requestPermission();
        }
      },
    );
  }
}
