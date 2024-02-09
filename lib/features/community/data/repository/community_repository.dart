import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/community/data/data_source/community_data_source.dart';
import 'package:carbon_zero/features/community/data/data_source/icommunity.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will communicate with the data source to get the data
/// and send it to the View Model
class CommunityRepository extends ICommunity {
  /// will communicate with the data source to get the data
  /// and send it to the View Model
  CommunityRepository({required CommunityDataSource communityDataSource})
      : _communityDataSource = communityDataSource;

  /// remote data source for the community feature
  final CommunityDataSource _communityDataSource;

  @override
  Future<void> createCommunity(CommunityModel community) async {
    return _communityDataSource.createCommunity(community);
  }

  @override
  Future<void> updateCommunity(CommunityModel community) async {
    return _communityDataSource.updateCommunity(community);
  }

  @override
  Stream<List<CommunityModel>> getCommunities(String userId) {
    return _communityDataSource.getCommunities(userId);
  }

  @override
  Stream<List<CommunityModel>> getUserCommunities(
    String userId,
  ) {
    return _communityDataSource.getUserCommunities(userId);
  }

  @override
  Future<List<CommunityModel>> getAdminCommunities(String adminId) async {
    return _communityDataSource.getAdminCommunities(adminId);
  }

  @override
  Future<void> deleteCommunity(String communityId) async {
    return _communityDataSource.deleteCommunity(communityId);
  }

  @override
  Future<void> joinCommunity(String userId, String communityId) {
    return _communityDataSource.joinCommunity(userId, communityId);
  }

  @override
  Future<List<UserModel>> getUsers(List<String> userIds) async {
    return _communityDataSource.getUsers(userIds);
  }

  @override
  Future<List<CommunityModel>> searchCommunities(String searchTerm) async {
    return _communityDataSource.searchCommunities(searchTerm);
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
