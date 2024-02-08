import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/data/repository/community_repository.dart';
import 'package:carbon_zero/features/community/presentation/view_models/community_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_face_pile/flutter_face_pile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// will show the details of a community
class CommunityDetails extends ConsumerWidget {
  /// constructor call
  const CommunityDetails({required this.community, super.key});

  /// community model
  final CommunityModel community;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final communityViewModel = ref.watch(communityViewModelProvider);
    final isLoading = communityViewModel is AsyncLoading;
    final user = ref.watch(userStreamProvider);
    final communityUsers = ref.watch(communityUsersProvider(community.userIds));
    ref.listen(communityViewModelProvider, (previous, next) {
      next.whenOrNull(
        error: (error, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text(error is Failure ? error.message : error.toString()),
            ),
          );
        },
      );
    });
    return PopScope(
      onPopInvoked: (_) {
        ref
          ..invalidate(userCommunityStreamProvider)
          ..invalidate(getCommunitiesStreamProvider);
      },
      child: Scaffold(
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 350,
                  width: MediaQuery.sizeOf(context).width,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      onError: (exception, stackTrace) => const SizedBox(),
                      filterQuality: FilterQuality.high,
                      fit: BoxFit.cover,
                      image: NetworkImage(community.posterId),
                    ),
                  ),
                ),
                // Image.asset(
                //   'assets/images/solar_energy.png',
                //   height: 300,
                //   width: MediaQuery.sizeOf(context).width,
                // ),
                Positioned(
                  top: 40,
                  left: 10,
                  child: IconButton.filled(
                    color: context.colors.secondary,
                    iconSize: 12,
                    style: ButtonStyle(
                      padding: const MaterialStatePropertyAll(
                        EdgeInsets.zero,
                      ),
                      backgroundColor: MaterialStatePropertyAll(
                        context.colors.secondary.withOpacity(.62),
                      ),
                      shape: MaterialStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    onPressed: () => context.pop(),
                    icon: const Icon(
                      Icons.arrow_back_ios_new,
                    ),
                  ),
                ),
              ],
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        community.name,
                        style: context.textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                      const SizedBox(height: 10),
                      // probable use read more text
                      Text(
                        community.description,
                        style: context.textTheme.labelSmall,
                      ),
                      const SizedBox(
                        height: 10,
                      ),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            child: communityUsers.when(
                              data: (users) {
                                if (users.isEmpty) return const SizedBox();
                                return FacePile(
                                  faces: users
                                      .map(
                                        (user) => FaceHolder(
                                          id: user.userId!,
                                          name: user.fName,
                                          avatar: NetworkImage(
                                            user.photoId ?? '',
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  faceSize: 50,
                                  facePercentOverlap: .4,
                                  backgroundColor: context.colors.background,
                                );
                              },
                              error: (error, _) => Text(
                                error is Failure
                                    ? error.message
                                    : error.toString(),
                              ),
                              loading: CircularProgressIndicator.new,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Chip(
                            avatar: SvgPicture.asset(
                              'assets/images/community-icon.svg',
                              width: 24,
                              colorFilter: ColorFilter.mode(
                                context.colors.primary,
                                BlendMode.srcIn,
                              ),
                            ),
                            label: Text(
                              '${community.members} ${community.members == 1 ? "member" : "members"}',
                            ),
                            side: BorderSide.none,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Expanded(
                            child: Text(
                              community.tags.join(', '),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 50),
                      PrimaryButton(
                        text: 'Join Community',
                        isLoading: isLoading,
                        onPressed: !isLoading
                            ? () async {
                                if (user.value != null) {
                                  final isMember = community.userIds
                                      .contains(user.value!.userId);
                                  if (isMember) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'You are already a member of this community',
                                        ),
                                      ),
                                    );
                                    return;
                                  }
                                  await ref
                                      .read(communityViewModelProvider.notifier)
                                      .joinCommunity(
                                        community.id!,
                                        user.value!.userId!,
                                      );
                                  if (context.mounted) context.pop();
                                }
                              }
                            : null,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
