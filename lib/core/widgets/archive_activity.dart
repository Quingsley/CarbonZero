import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Archive activity dialog
Future<void> archiveActivity(
  ActivityModel activity,
  BuildContext context,
) async {
  await showAdaptiveDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) => ArchiveDialog(activity: activity),
  );
}

/// Archive activity dialog
class ArchiveDialog extends ConsumerWidget {
  /// Create const instance of [ArchiveDialog] widget.
  const ArchiveDialog({required this.activity, super.key});

  /// The activity.
  final ActivityModel activity;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activityVm = ref.watch(activityViewModelProvider);
    final isLoading = activityVm is AsyncLoading;
    ref.listen(activityViewModelProvider, (previous, next) {
      next.whenOrNull(
        data: (_) {
          ref.invalidate(
            getActivitiesStreamProvider((activity.id!, activity.type)),
          );
          if (activity.type == ActivityType.community) {
            ref.invalidate(communityActivityStreamProvider);
          }
          context.pop();
        },
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: context.colors.error,
              content:
                  Text(error is Failure ? error.message : error.toString()),
            ),
          );
        },
      );
    });
    return AlertDialog(
      title: const Text('Activity Ended'),
      content: const Text(
        'This activity has ended do you want to archive it?',
      ),
      actions: <Widget>[
        TextButton(
          onPressed: isLoading
              ? null
              : () async {
                  await ref
                      .read(activityViewModelProvider.notifier)
                      .archiveActivity(activity.id!);
                },
          child:
              isLoading ? const CircularProgressIndicator() : const Text('Yes'),
        ),
        TextButton(
          onPressed: () => isLoading ? null : context.pop(),
          child: const Text('No'),
        ),
      ],
    );
  }
}
