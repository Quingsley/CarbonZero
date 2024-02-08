import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/community/data/data_source/community_data_source.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will communicate with the data source to get the data
/// and send it to the View Model
class CommunityRepository {
  /// will communicate with the data source to get the data
  /// and send it to the View Model
  CommunityRepository({required CommunityDataSource communityDataSource})
      : _communityDataSource = communityDataSource;

  /// remote data source for the community feature
  final CommunityDataSource _communityDataSource;

  /// create a community
  Future<void> createCommunity(CommunityModel community) async {
    return _communityDataSource.createCommunity(community);
  }

  /// updates the community
  Future<void> updateCommunity(CommunityModel community) async {
    return _communityDataSource.updateCommunity(community);
  }

  /// will get the communities in the db
  Stream<List<CommunityModel>> getCommunities(String userId) {
    return _communityDataSource.getCommunities(userId);
  }

  /// get the communities of the user
  Stream<List<CommunityModel>> getUserCommunities(
    String userId,
  ) {
    return _communityDataSource.getUserCommunities(userId);
  }

  /// fetch only the communities that the user is an admin of
  Future<List<CommunityModel>> getAdminCommunities(String adminId) async {
    return _communityDataSource.getAdminCommunities(adminId);
  }

  /// will delete the community
  Future<void> deleteCommunity(String communityId) async {
    return _communityDataSource.deleteCommunity(communityId);
  }

  /// method to let user join a community
  Future<void> joinCommunity(String communityId, String userId) {
    return _communityDataSource.joinCommunity(userId, communityId);
  }

  /// will only get users of a specific communities
  Future<List<UserModel>> getUsers(List<String> userIds) async {
    return _communityDataSource.getUsers(userIds);
  }

  /// search for communities in the for the given search term
  Future<List<CommunityModel>> searchCommunities(String query) async {
    return _communityDataSource.searchCommunities(query);
  }
}

/// provider for the community repository
final communityRepositoryProvider = Provider<CommunityRepository>((ref) {
  final dataSource = ref.read(communityDataSourceProvider);
  return CommunityRepository(communityDataSource: dataSource);
});

/// get members of the given community
final communityUsersProvider = FutureProvider.autoDispose
    .family<List<UserModel>, List<String>>((ref, userIds) {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getUsers(userIds);
});
