import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/rewards/presentation/widgets/reward_progress_card.dart';
import 'package:carbon_zero/features/rewards/presentation/widgets/reward_progress_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will display all the challenges that are ongoing in the community
class OngoingChallenges extends ConsumerWidget {
  /// constructor call
  const OngoingChallenges({required this.communityId, super.key});

  /// community Id
  final String communityId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activitiesAsyncValue = ref.watch(
      communityActivityStreamProvider(
        communityId,
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Ongoing Challenges'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: activitiesAsyncValue.when(
          data: (challenges) {
            if (challenges.isEmpty) {
              return const Center(
                child: Text('No ongoing challenges'),
              );
            } else {
              return ListView.builder(
                itemCount: challenges.length,
                itemBuilder: (context, index) {
                  return RewardProgressCard(
                    activityModel: challenges[index],
                  );
                },
              );
            }
          },
          error: (error, _) => Center(
            child: Text(error is Failure ? error.message : error.toString()),
          ),
          loading: RewardProgressSkeleton.new,
        ),
      ),
    );
  }
}
