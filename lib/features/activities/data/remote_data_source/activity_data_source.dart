import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// This is the abstract class for the activity data source.
abstract class IActivityDataSource {
  /// This method will create an activity in the database.
  Future<void> createActivity(ActivityModel activity);

  /// This method will get all the activities from the database
  /// of a given user / community.
  Stream<List<ActivityModel>> getActivities(String parentId);

  /// This method will creating a recording in the db and update the progress
  /// of the user / community
  Future<void> recordActivity(ActivityRecordingModel activity);
}

/// This is the remote data source for the activity feature.
class ActivityDataSource implements IActivityDataSource {
  /// This is the remote data source for the activity feature.
  ActivityDataSource({required FirebaseFirestore db}) : _db = db;

  final FirebaseFirestore _db;

  /// This method will create an activity in the database.
  @override
  Future<void> createActivity(ActivityModel activity) async {
    try {
      final doc = await _db
          .collection('activities')
          .withActivityModelConverter()
          .add(activity);

      await doc.update({
        'id': doc.id,
      });
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ActivityModel>> getActivities(String parentId) {
    try {
      final snapshot = _db
          .collection('activities')
          .withActivityModelConverter()
          .where('parentId', isEqualTo: parentId)
          .snapshots();

      return snapshot
          .map((event) => event.docs.map((doc) => doc.data()).toList());
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> recordActivity(ActivityRecordingModel activity) async {
    try {
      final doc = await _db
          .collection('activity_recordings')
          .withActivityRecordingModelConverter()
          .add(activity);

      await doc.update({'id': doc.id});

      /// should I use cloud functions or do it manually ??
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }
}

/// This is the provider for the activity data source.
final activityDataSourceProvider = Provider<ActivityDataSource>((ref) {
  final db = ref.read(dbProvider);
  if (db == null) {
    throw AssertionError('Firestore is not initialized, User is not logged in');
  }
  return ActivityDataSource(db: db);
});
