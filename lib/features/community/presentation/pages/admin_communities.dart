import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// will only show the communities that the user is an admin of
class AdminCommunities extends ConsumerWidget {
  /// will only show the communities that the user is an admin of
  const AdminCommunities({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authInstanceProvider);
    final communityViewModel = ref.watch(communityViewModelProvider);
    final isLoading = communityViewModel is AsyncLoading;
    final adminCommunitiesAsyncValue =
        ref.watch(adminCommunityFutureProvider(user.currentUser!.uid));
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage your communities'),
        centerTitle: true,
      ),
      body: adminCommunitiesAsyncValue.when(
        data: (community) {
          return community.isEmpty
              ? const Center(child: Text('You do not own any communities'))
              : ListView.builder(
                  itemCount: community.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(community[index].posterId),
                      ),
                      title: Text(
                        community[index].name,
                        style: context.textTheme.labelLarge
                            ?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        community[index].description,
                        style: context.textTheme.labelSmall,
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton.filledTonal(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              context.go(
                                '/community/add-community',
                                extra: community[index],
                              );
                            },
                          ),
                          IconButton.filledTonal(
                            key: ValueKey(community[index].id),
                            color: context.colors.error,
                            icon: !isLoading
                                ? const Icon(
                                    Icons.delete,
                                  )
                                : CircularProgressIndicator(
                                    key: ValueKey(community[index].id),
                                  ),
                            onPressed: !isLoading
                                ? () async {
                                    await ref
                                        .read(
                                          communityViewModelProvider.notifier,
                                        )
                                        .deleteCommunity(community[index].id!);
                                    ref
                                      ..invalidate(adminCommunityFutureProvider)
                                      ..invalidate(userCommunityStreamProvider)
                                      ..invalidate(
                                        getCommunitiesStreamProvider,
                                      );
                                  }
                                : null,
                          ),
                        ],
                      ),
                    );
                  },
                );
        },
        error: (error, stackTrace) => Center(
          child: Text(error is Failure ? error.message : error.toString()),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
