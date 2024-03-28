import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/rewards/presentation/widgets/reward_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// skeleton when loading communities in community screen
class RewardProgressSkeleton extends StatelessWidget {
  /// constructor
  const RewardProgressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: _fakeActivities.length,
        itemBuilder: (context, index) {
          return RewardProgressCard(
            activityModel: _fakeActivities[index],
          );
        },
      ),
    );
  }
}

final _fakeActivities = List.filled(
  4,
  ActivityModel(
    color: Colors.grey.shade100.value,
    description: BoneMock.name,
    endDate: BoneMock.time,
    name: BoneMock.name,
    cO2Emitted: 20,
    type: ActivityType.community,
    parentId: BoneMock.name,
    reminderTime: BoneMock.time,
    members: 20,
    progress: .5,
    startDate: BoneMock.time,
    icon:
        'https://firebasestorage.googleapis.com/v0/b/carbonzero-53d68.appspot.com/o/broccoli.png?alt=media&token=9e755947-2a3c-4821-9abd-ee93775700b8',
  ),
);
