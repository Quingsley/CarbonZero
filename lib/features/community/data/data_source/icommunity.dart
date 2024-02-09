import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';

/// an abstract class containing use cases for community feature
abstract class ICommunity {
  /// adds a community to the database
  Future<void> createCommunity(CommunityModel community);

  /// updates the community
  Future<void> updateCommunity(CommunityModel community);

  /// will get all the communities in the db that the user
  /// has not joined
  Stream<List<CommunityModel>> getCommunities(String userId);

  /// will get specific communities for the user
  Stream<List<CommunityModel>> getUserCommunities(
    String userId,
  );

  /// will only return admin communities
  Future<List<CommunityModel>> getAdminCommunities(String adminId);

  /// will delete the community
  Future<void> deleteCommunity(String communityId);

  /// will let the user join the community
  Future<void> joinCommunity(String userId, String communityId);

  /// searches a given community for the given search term
  Future<List<CommunityModel>> searchCommunities(String searchTerm);

  /// will get the users of a given community
  Future<List<UserModel>> getUsers(List<String> userIds);
}
