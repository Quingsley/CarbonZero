import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:carbon_zero/features/community/presentation/widgets/community_card.dart';
import 'package:carbon_zero/features/community/presentation/widgets/community_search.dart';
import 'package:carbon_zero/features/community/presentation/widgets/user_community_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// users will be able to find communities and join them
/// and have group chats with the members of the community
class CommunityScreen extends ConsumerWidget {
  /// constructor call
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);

    final getCommunityAsyncValue =
        ref.watch(getCommunitiesStreamProvider(user.value!.userId!));

    final getUserCommunityAsyncValue =
        ref.watch(userCommunityStreamProvider(user.value!.userId!));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Community'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              child: CommunitySearch(),
            ),
            const SizedBox(height: 8),
            const Text(
              'Top Communities',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 250,
              child: getCommunityAsyncValue.when(
                data: (communities) {
                  return communities.isNotEmpty
                      ? ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: (context, index) {
                            return CommunityCard(
                              community: communities[index],
                            );
                          },
                          scrollDirection: Axis.horizontal,
                        )
                      : const Center(
                          child: Text(
                            'Nothing to show here, create a community ',
                          ),
                        );
                },
                error: (error, _) {
                  return Center(
                    child: Text(
                      error is Failure ? error.message : error.toString(),
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            const Text(
              'Your Community Chats',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: getUserCommunityAsyncValue.when(
                data: (communities) {
                  return communities.isNotEmpty
                      ? ListView.builder(
                          itemCount: communities.length,
                          itemBuilder: (context, index) {
                            return UserCommunityCard(
                              community: communities[index],
                            );
                          },
                        )
                      : const Text(
                          'You  have not joined any communities yet , please join one',
                        );
                },
                error: (error, _) => Center(
                  child: Text(
                    error is Failure ? error.message : error.toString(),
                  ),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
        tooltip: 'Add a new community',
        onPressed: () => context.go('/community/add-community'),
        child: const Icon(
          Icons.add,
        ),
      ),
    );
  }
}
