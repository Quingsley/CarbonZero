import 'dart:async';

import 'package:carbon_zero/algorithm.dart';
import 'package:carbon_zero/core/constants/constants.dart';
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
    ActivityType type,
  ) async {
    final repo = ref.read(activityRepositoryProvider);
    final updatedARecord = activityRecordingModel.copyWith(
      co2Emitted: getCo2emitted(activityRecordingModel),
    );
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repo.recordActivity(updatedARecord, type),
    );
  }

  /// will add a new participant to the activity
  Future<void> addParticipant(String activityId, String userId) async {
    final repo = ref.read(activityRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repo.addParticipants(activityId, userId),
    );
  }
}

/// provides the activity VM to the UI
final activityViewModelProvider =
    AsyncNotifierProvider<ActivityViewModel, void>(ActivityViewModel.new);

/// will get the live snapshot of the user/ community activities
final getActivitiesStreamProvider =
    StreamProvider.family<List<ActivityModel>, (String?, ActivityType)>(
        (ref, args) {
  final repo = ref.read(activityRepositoryProvider);
  return repo.getActivities(args.$1, args.$2);
});

/// will get the activities recorded by the user
final getActivityRecodingFutureProvider =
    FutureProvider.family<List<ActivityRecordingModel>, (String, DateTime)>(
  (ref, data) {
    final repo = ref.read(activityRepositoryProvider);
    return repo.getActivityRecordings(data.$1, data.$2);
  },
);

/// will stream for changes for a single activity
final getSingleActivityProvider =
    StreamProvider.family<ActivityModel, String>((ref, activityId) {
  final repo = ref.read(activityRepositoryProvider);
  return repo.getSingleActivity(activityId);
});

/// will get the activities of a given community
final communityActivityStreamProvider =
    StreamProvider.family<List<ActivityModel>, String>((ref, communityId) {
  final repo = ref.read(activityRepositoryProvider);
  return repo.getCommunityActivities(communityId);
});

/// chart data future provider
final chartDataFutureProvider =
    FutureProviderFamily<List<Map<String, dynamic>>, String>(
  (ref, userId) {
    final repo = ref.read(activityRepositoryProvider);
    return repo.getChartData(userId);
  },
);
