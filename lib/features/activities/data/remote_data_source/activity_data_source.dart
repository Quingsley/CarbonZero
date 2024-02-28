import 'package:carbon_zero/core/constants/constants.dart';
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
  /// of a given user / community (only if parent Id exists on the participants).
  Stream<List<ActivityModel>> getActivities(
    String? parentId,
    ActivityType activityType,
  );

  /// This method will get a single activity from the database
  Stream<ActivityModel> getSingleActivity(String activityId);

  /// This method will creating a recording in the db and update the progress
  /// of the user / community
  Future<void> recordActivity(
    ActivityRecordingModel activity,
    ActivityType type,
  );

  /// will return recordings of a given activity for a given day
  Future<List<ActivityRecordingModel>> getActivityRecordings(
    String activityId,
    DateTime date,
  );

  /// will get activities of a given community
  Stream<List<ActivityModel>> getCommunityActivities(
    String communityId,
  );

  /// update the list of participants in an activity
  Future<void> addParticipants(
    String activityId,
    String userId,
  );
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
  Stream<List<ActivityModel>> getActivities(
    String? parentId,
    ActivityType type,
  ) {
    try {
      if (type == ActivityType.individual) {
        final snapshot = _db
            .collection('activities')
            .withActivityModelConverter()
            .where('parentId', isEqualTo: parentId)
            .snapshots();

        return snapshot
            .map((event) => event.docs.map((doc) => doc.data()).toList());
      } else {
        final snapshot = _db
            .collection('activities')
            .withActivityModelConverter()
            .where('type', isEqualTo: ActivityType.community.name)
            .where('participants', arrayContains: parentId)
            .snapshots();
        return snapshot
            .map((event) => event.docs.map((doc) => doc.data()).toList());
      }
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> recordActivity(
    ActivityRecordingModel activity,
    ActivityType type,
  ) async {
    try {
      final doc = await _db
          .collection('activity_recordings')
          .withActivityRecordingModelConverter()
          .add(activity);

      await doc.update({'id': doc.id});

      /// update the progress of the user / community
      final activityDoc = await _db
          .collection('activities')
          .withActivityModelConverter()
          .doc(activity.activityId)
          .get();
      if (type == ActivityType.individual) {
        final totalDocuments = await _db
            .collection('activity_recordings')
            .where('activityId', isEqualTo: activity.activityId)
            .get();
        final userActivity = activityDoc.data()!;
        final startDate = DateTime.parse(userActivity.startDate);
        final endDate = DateTime.parse(userActivity.endDate);
        final expectedTotalActivities = endDate.difference(startDate).inDays;
        final actualTotalActivities = totalDocuments.docs.length;
        final progress = actualTotalActivities / expectedTotalActivities;

        /// TODO: use cloud function here
        await activityDoc.reference.update({
          'carbonPoints':
              FieldValue.increment(activity.imageUrl.isEmpty ? 1 : 3),
          'cO2Emitted': FieldValue.increment(25), // 25 g (estimate)
          'progress': progress,
        });
      } else {
        //TODO: should be done by a cloud function using pub sub
        final now = DateTime.now();
        final startOfDay = DateTime(now.year, now.month, now.day);
        final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

        // gets the total number of recordings for a given activity
        // done in a day for a community
        final totalDocumentsInADay = await _db
            .collection('activity_recordings')
            .where(
              'date',
              isGreaterThanOrEqualTo: startOfDay.toIso8601String(),
            )
            .where('date', isLessThanOrEqualTo: endOfDay.toIso8601String())
            .where('activityId', isEqualTo: activity.activityId)
            .where('type', isEqualTo: ActivityType.community.name)
            .get();
        final communityActivity = activityDoc.data()!;
        final startDate = DateTime.parse(communityActivity.startDate);
        final endDate = DateTime.parse(communityActivity.endDate);
        // total number of contributions expected by all members of
        //the community  when the challenge ends
        final expectedTotalActivities = endDate.difference(startDate).inDays *
            communityActivity.participants.length;
        final activitiesDoneInADay = totalDocumentsInADay.docs.length;
        final progress = activitiesDoneInADay / expectedTotalActivities;
        // update the progress of the community
        await activityDoc.reference.update({
          'carbonPoints':
              FieldValue.increment(activity.imageUrl.isEmpty ? 1 : 3),
          'cO2Emitted': FieldValue.increment(25), // 25 g (estimate)
          'progress': FieldValue.increment(progress),
        });
      }
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<ActivityRecordingModel>> getActivityRecordings(
    String activityId,
    DateTime date,
  ) async {
    try {
      final startDate = DateTime(date.year, date.month, date.day);
      final endDate = DateTime(date.year, date.month, date.day, 23, 59, 59);
      final snapshot = await _db
          .collection('activity_recordings')
          .withActivityRecordingModelConverter()
          .where('activityId', isEqualTo: activityId)
          .where(
            'date',
            isGreaterThanOrEqualTo: startDate.toIso8601String(),
          )
          .where('date', isLessThanOrEqualTo: endDate.toIso8601String())
          .get();

      return snapshot.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<ActivityModel> getSingleActivity(String activityId) {
    try {
      final snapshot = _db
          .collection('activities')
          .withActivityModelConverter()
          .doc(activityId)
          .snapshots();

      return snapshot.map((event) => event.data()!);
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<ActivityModel>> getCommunityActivities(String communityId) {
    try {
      final snapshot = _db
          .collection('activities')
          .withActivityModelConverter()
          .where('type', isEqualTo: ActivityType.community.name)
          .where('parentId', isEqualTo: communityId)
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
  Future<void> addParticipants(String activityId, String userId) async {
    try {
      final activityDoc = await _db
          .collection('activities')
          .withActivityModelConverter()
          .doc(activityId)
          .get();
      final activity = activityDoc.data()!;
      final participants = activity.participants;
      if (!participants.contains(userId)) {
        await activityDoc.reference.update({
          'participants': FieldValue.arrayUnion([userId]),
        });
      }
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
