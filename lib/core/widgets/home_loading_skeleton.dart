import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/home/presentation/widgets/activity_tile.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// skeleton when loading activities in home screen
class HomeLoadingSkeleton extends StatelessWidget {
  /// constructor
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: _fakeActivities.length,
        itemBuilder: (context, index) {
          return Card(
            child: ActivityTile(
              activity: _fakeActivities[index],
            ),
          );
        },
      ),
    );
  }
}

final _fakeActivities = List.filled(
  7,
  ActivityModel(
    color: Colors.grey.shade200.value,
    description: BoneMock.name,
    endDate: BoneMock.time,
    name: BoneMock.name,
    cO2Emitted: 20,
    type: ActivityType.individual,
    parentId: BoneMock.name,
    reminderTime: BoneMock.time,
    members: 20,
    progress: .5,
    startDate: BoneMock.time,
    icon: BoneMock.name,
  ),
);
