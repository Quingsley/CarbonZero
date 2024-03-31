import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/features/activities/data/models/activity_recording_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

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

  /// Get the data for the chart
  Future<List<Map<String, dynamic>>> getChartData(String userId);
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

      if (activity.type == ActivityType.individual) {
        await _db.collection('users').doc(activity.parentId).update({
          'totalCarbonPoints':
              FieldValue.increment(1), // 1 point for creating an activity
        });
      } else {
        final communityDoc = await _db
            .collection('communities')
            .withCommunityModelConverter()
            .doc(activity.parentId)
            .get();
        final data = communityDoc.data()!;
        await _db.collection('users').doc(data.adminId).update({
          'totalCarbonPoints': FieldValue.increment(
            3,
          ), // 3 point for creating a community activity
        });
      }
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
    ActivityRecordingModel recording,
    ActivityType type,
  ) async {
    try {
      final doc = await _db
          .collection('activity_recordings')
          .withActivityRecordingModelConverter()
          .add(recording);

      await doc.update({'id': doc.id});

      /// update the progress of the user / community
      final activityDoc = await _db
          .collection('activities')
          .withActivityModelConverter()
          .doc(recording.activityId)
          .get();
      if (type == ActivityType.individual) {
        final totalDocuments = await _db
            .collection('activity_recordings')
            .where('activityId', isEqualTo: recording.activityId)
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
              FieldValue.increment(recording.imageUrl.isEmpty ? 1 : 3),
          'cO2Emitted': FieldValue.increment(recording.co2Emitted),
          'progress': progress,
        });
      } else {
        //TODO: should be done by a cloud function using pub sub
        final now = DateTime.now().toUtc();
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
            .where('activityId', isEqualTo: recording.activityId)
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
              FieldValue.increment(recording.imageUrl.isEmpty ? 1 : 3),
          'cO2Emitted': FieldValue.increment(recording.co2Emitted),
          'progress': progress,
        });
      }

      /// update the carbonFootPrintNow of the user
      final user = await _db
          .collection('users')
          .withUserModelConverter()
          .doc(recording.userId)
          .get();
      await user.reference.update({
        'carbonFootPrintNow': FieldValue.increment(25 / 1000), // in kg
        'totalCarbonPoints': FieldValue.increment(
          recording.imageUrl.isEmpty ? 7 : 15,
        ),
      });
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

  @override
  Future<List<Map<String, dynamic>>> getChartData(String userId) async {
    try {
      final sevenDaysAgo = DateTime.now().subtract(const Duration(days: 7));
      final snapshot = await _db
          .collection('activity_recordings')
          .withActivityRecordingModelConverter()
          .where('userId', isEqualTo: userId)
          .where('parentId', isEqualTo: userId)
          .where(
            'date',
            isGreaterThanOrEqualTo: sevenDaysAgo.toIso8601String(),
          )
          .get();
      // Group the documents by date and find the
      // document with the highest co2emitted for each day
      final highestEmissionsPerDay =
          <String, QueryDocumentSnapshot<ActivityRecordingModel>>{};
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final date = DateTime.parse(data.date);
        final dateString = DateFormat('dd-MM-yyyy').format(date);
        if (highestEmissionsPerDay.containsKey(dateString)) {
          final currentHighest = highestEmissionsPerDay[dateString]!.data();
          if (currentHighest.co2Emitted < data.co2Emitted) {
            highestEmissionsPerDay[dateString] = doc;
          }
        } else {
          highestEmissionsPerDay[dateString] = doc;
        }
        // Query the activities collection and combine the data
      }
      final chartData = <Map<String, dynamic>>[];
      for (final doc in highestEmissionsPerDay.values) {
        final snapshot = await _db
            .collection('activities')
            .withActivityModelConverter()
            .doc(doc.data().activityId)
            .get();
        chartData.add({
          'date': DateFormat('E').format(DateTime.parse(doc.data().date)),
          'co2Emitted': doc.data().co2Emitted,
          'title': snapshot.data()?.name,
          'color': snapshot.data()?.color,
        });
      }
      return chartData;
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
