import 'dart:async';

import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/data/repository/community_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will read data from the community repo and return it to the view
class CommunityViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  /// create community method
  Future<void> createCommunity(CommunityModel community) async {
    final repo = ref.read(communityRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.createCommunity(community));
  }

  /// uPdate the community
  Future<void> updateCommunity(CommunityModel community) async {
    final repo = ref.read(communityRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.updateCommunity(community));
  }

  /// delete community
  Future<void> deleteCommunity(String id) async {
    final repo = ref.read(communityRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() => repo.deleteCommunity(id));
  }

  /// join community
  Future<void> joinCommunity(String communityId, String userId) async {
    final repo = ref.read(communityRepositoryProvider);
    state = const AsyncLoading();
    state =
        await AsyncValue.guard(() => repo.joinCommunity(userId, communityId));
    ref.invalidate(userCommunityStreamProvider);
  }
}

/// provider for the community view model
final communityViewModelProvider =
    AsyncNotifierProvider<CommunityViewModel, void>(CommunityViewModel.new);

/// will fetch communities from the server
final getCommunitiesStreamProvider =
    StreamProvider.autoDispose.family<List<CommunityModel>, String>((ref, arg) {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getCommunities(arg);
});

/// will only return the communities that the user is a part of
final userCommunityStreamProvider =
    StreamProvider.autoDispose.family<List<CommunityModel>, String>((ref, arg) {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getUserCommunities(arg);
});

/// admin communities
final adminCommunityFutureProvider =
    AutoDisposeFutureProviderFamily<List<CommunityModel>, String>(
        (ref, userId) {
  final repo = ref.read(communityRepositoryProvider);
  return repo.getAdminCommunities(userId);
});

/// listen to the stream of searched communities
final searchCommunitiesFutureProvider =
    FutureProvider.autoDispose.family<List<CommunityModel>, String>((ref, arg) {
  final repo = ref.read(communityRepositoryProvider);
  return repo.searchCommunities(arg);
});
