import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// remote data source for the community feature
class CommunityDataSource {
  /// remote data source for the community feature
  CommunityDataSource({required FirebaseFirestore? db})
      : assert(db != null, 'db must not be null'),
        _db = db!;

  /// firestore instance
  final FirebaseFirestore _db;

  /// adds a community to the database
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
      });
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  /// updates the community
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

  /// will get all the communities in the db that the user
  /// has not joined
  Stream<List<CommunityModel>> getCommunities(String userId) {
    try {
      final data =
          _db.collection('communities').withCommunityModelConverter().where(
        //FIX: Not working I only want to get the communities that the user has not joined(quick fix below)
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

  /// will get specific communities for the user
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

  /// will only return admin communities
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

  /// will delete the community
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

  /// will let the user join the community
  Future<void> joinCommunity(String userId, String communityId) async {
    try {
      await _db.collection('communities').doc(communityId).update({
        'userIds': FieldValue.arrayUnion([userId]),
        'members': FieldValue.increment(1),
      });
      await _db.collection('users').doc(userId).update({
        'communityIds': FieldValue.arrayUnion([communityId]),
      });
    } on FirebaseException catch (e) {
      throw Failure(message: e.message ?? e.toString());
    } catch (e) {
      rethrow;
    }
  }

  /// will get the users of a given community
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
  /// searches a given community for the given search term
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
