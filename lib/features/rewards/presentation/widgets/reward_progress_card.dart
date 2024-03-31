import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:firebase_cached_image/firebase_cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// card used to show the progress of the user in the rewards section
class RewardProgressCard extends ConsumerWidget {
  /// constructor call
  const RewardProgressCard({
    required this.activityModel,
    super.key,
  });

  /// activity model
  final ActivityModel activityModel;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);
    final hasJoined = activityModel.participants.contains(user.value?.userId);
    final activityVm = ref.watch(activityViewModelProvider);
    final isLoading = activityVm is AsyncLoading;
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        splashFactory: NoSplash.splashFactory,
        splashColor: context.colors.primary,
        onTap: () => context.push('/activity-details', extra: activityModel),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          elevation: 3,
          child: Row(
            children: [
              Container(
                width: MediaQuery.sizeOf(context).width * .3,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image:
                        FirebaseImageProvider(FirebaseUrl(activityModel.icon)),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.sizeOf(context).width * .03,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    activityModel.name,
                    style: context.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Chip(
                    avatar: SvgPicture.asset(
                      'assets/images/community-icon.svg',
                      width: 24,
                      colorFilter: ColorFilter.mode(
                        context.colors.tertiary,
                        BlendMode.srcIn,
                      ),
                    ),
                    labelPadding: EdgeInsets.zero,
                    label: Text(
                      '${activityModel.participants.length} ${activityModel.participants.length == 1 ? "member" : "members"}',
                    ),
                    side: BorderSide.none,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (hasJoined)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        SizedBox(
                          width: 170,
                          child: LinearProgressIndicator(
                            value: activityModel.progress,
                            backgroundColor: Colors.grey.withOpacity(.62),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(activityModel.color),
                            ),
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Text(
                          '${(activityModel.progress * 100).toStringAsFixed(2)}%',
                        ),
                      ],
                    ),
                  if (!hasJoined)
                    PrimaryButton(
                      text: 'Join Challenge',
                      isLoading: isLoading,
                      onPressed: isLoading
                          ? null
                          : () {
                              ref
                                  .read(activityViewModelProvider.notifier)
                                  .addParticipant(
                                    activityModel.id!,
                                    user.value!.userId!,
                                  );
                            },
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
