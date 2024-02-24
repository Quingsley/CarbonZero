import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:carbon_zero/features/activities/data/remote_data_source/activity_data_source.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ActivityRepository that reads from the remote data source
class ActivityRepository implements IActivityDataSource {
  /// [ActivityRepository] class constructor
  ActivityRepository({required ActivityDataSource dataSource})
      : _dataSource = dataSource;

  final ActivityDataSource _dataSource;
  @override
  Future<void> createActivity(ActivityModel activity) async {
    await _dataSource.createActivity(activity);
  }

  @override
  Stream<List<ActivityModel>> getActivities(String? parentId) {
    return _dataSource.getActivities(parentId);
  }

  @override
  Future<void> recordActivity(ActivityRecordingModel activity) async {
    await _dataSource.recordActivity(activity);
  }
}

/// activity repo provider
final activityRepositoryProvider = Provider<ActivityRepository>((ref) {
  final dataSource = ref.read(activityDataSourceProvider);
  return ActivityRepository(dataSource: dataSource);
});
