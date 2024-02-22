import 'dart:async';

import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:carbon_zero/features/activities/data/repositories/activity_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will read data from [ActivityRepository] and provide it
/// to the UI by managing error and loading states
class ActivityViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    throw UnimplementedError();
  }

  /// creates a new activity / goal of the user
  Future<void> createActivity(ActivityModel activityModel) async {
    final repo = ref.read(activityRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.createActivity(activityModel));
  }

  /// records the activity done for a given activity
  Future<void> recordActivity(
    ActivityRecordingModel activityRecordingModel,
  ) async {
    final repo = ref.read(activityRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repo.recordActivity(activityRecordingModel),
    );
  }
}

/// provides the activity VM to the UI
final activityViewModelProvider =
    AsyncNotifierProvider<ActivityViewModel, void>(ActivityViewModel.new);

/// will get the live snapshot of the user/ community activities
final getActivitiesStreamProvider =
    StreamProvider.family<List<ActivityModel>, String>((ref, parentId) {
  final repo = ref.read(activityRepositoryProvider);
  return repo.getActivities(parentId);
});
