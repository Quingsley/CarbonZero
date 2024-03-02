import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/community/data/data_source/icommunity.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// remote data source for the community feature
class CommunityDataSource extends ICommunity {
  /// remote data source for the community feature
  CommunityDataSource({required FirebaseFirestore? db})
      : assert(db != null, 'db must not be null'),
        _db = db!;

  /// firestore instance
  final FirebaseFirestore _db;

  @override
  Future<void> createCommunity(CommunityModel community) async {
    try {
      final doc = await _db
          .collection('communities')
          .withCommunityModelConverter()
          .add(community);
      await _db.collection('communities').doc(doc.id).update({
        'id': doc.id,
        'members': FieldValue.increment(1),
        'userIds': FieldValue.arrayUnion([community.adminId]),
      });
      // update the user with the community id
      await _db.collection('users').doc(community.adminId).update({
        'communityIds': FieldValue.arrayUnion([doc.id]),
        'totalCarbonPoints':
            FieldValue.increment(5), // 5 points for creating a community
      });
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateCommunity(CommunityModel community) async {
    try {
      await _db
          .collection('communities')
          .withCommunityModelConverter()
          .doc(community.id)
          .set(community);
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<CommunityModel>> getCommunities(String userId) {
    try {
      final data =
          _db.collection('communities').withCommunityModelConverter().where(
        //FIX: Not working I only want to get the communities that
        //the user has not joined(quick fix below)
        'userIds',
        isNotEqualTo: [
          userId,
        ],
      ).snapshots();
      return data.map(
        (event) => event.docs
            .map((doc) => doc.data())
            .where((community) => !community.userIds.contains(userId))
            .toList(),
      );
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<CommunityModel>> getUserCommunities(
    String userId,
  ) {
    try {
      final data = _db
          .collection('communities')
          .withCommunityModelConverter()
          .where('userIds', arrayContains: userId)
          .snapshots();
      return data.map((event) => event.docs.map((doc) => doc.data()).toList());
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<CommunityModel>> getAdminCommunities(String adminId) async {
    try {
      final data = await _db
          .collection('communities')
          .withCommunityModelConverter()
          .where('adminId', isEqualTo: adminId)
          .get();
      return data.docs.map((community) => community.data()).toList();
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteCommunity(String communityId) async {
    try {
      await _db.collection('communities').doc(communityId).delete();
      await _db
          .collection('users')
          .withCommunityModelConverter()
          .where('communityIds', arrayContains: communityId)
          .get()
          .then((value) {
        for (final element in value.docs) {
          element.reference.update({
            'communityIds': FieldValue.arrayRemove([communityId]),
          });
        }
      });
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> joinCommunity(String userId, String communityId) async {
    try {
      await _db.collection('communities').doc(communityId).update({
        'userIds': FieldValue.arrayUnion([userId]),
        'members': FieldValue.increment(1),
      });
      await _db.collection('users').doc(userId).update({
        'communityIds': FieldValue.arrayUnion([communityId]),
        'totalCarbonPoints': FieldValue.increment(2), // 2 points for joining
      });
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<UserModel>> getUsers(List<String> userIds) async {
    try {
      final data = await _db
          .collection('users')
          .withUserModelConverter()
          .where('userId', whereIn: userIds)
          .get();
      return data.docs.map((user) => user.data()).toList();
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  //TODO: find a better way to optimize the search
  @override
  Future<List<CommunityModel>> searchCommunities(String searchTerm) async {
    try {
      final data = await _db
          .collection('communities')
          .withCommunityModelConverter()
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where(
            'name',
            isLessThanOrEqualTo: '$searchTerm\uf7ff',
          ) //(\uf7ff)  the last known  unicode character
          .get();
      return data.docs.map((doc) => doc.data()).toList();
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }
}

/// provider for the community data source
final communityDataSourceProvider = Provider<CommunityDataSource>(
  (ref) => CommunityDataSource(db: ref.read(dbProvider)),
);
