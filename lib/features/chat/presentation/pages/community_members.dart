import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/features/community/data/repository/community_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will have a list of community members of a given community
class CommunityMembers extends ConsumerWidget {
  /// constructor call
  const CommunityMembers({required this.userIds, super.key});

  /// userIds of the community
  final List<String> userIds;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityUsers = ref.watch(communityUsersProvider(userIds));
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Community Members'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: communityUsers.when(
          data: (users) {
            if (users.isEmpty) {
              return const Center(
                child: Text('No members in this community'),
              );
            } else {
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(users[index].photoId ?? ''),
                    ),
                    title: Text(users[index].fName),
                  );
                },
              );
            }
          },
          error: (error, _) {
            return Center(
              child: Text(error is Failure ? error.message : error.toString()),
            );
          },
          loading: () {
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
