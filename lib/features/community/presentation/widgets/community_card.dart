import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// community card widget used to display a community
/// in the community screen
class CommunityCard extends StatelessWidget {
  /// constructor call
  const CommunityCard({
    required this.community,
    super.key,
  });

  /// community model
  final CommunityModel community;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          onError: (exception, stackTrace) => const SizedBox(),
          image: NetworkImage(community.posterId),
          fit: BoxFit.cover,
        ),
        color: context.colors.primaryContainer,
      ),
      width: MediaQuery.sizeOf(context).width * .9,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.sizeOf(context).width,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: context.colors.primary.withOpacity(.52),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  community.name,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  community.description,
                  style: context.textTheme.titleSmall
                      ?.copyWith(color: context.colors.onPrimary),
                ),
                const SizedBox(width: 6),
                Text(
                  community.tags.join(', '),
                  style: context.textTheme.labelSmall
                      ?.copyWith(color: context.colors.onPrimary),
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.people_alt,
                      size: 16,
                      color: context.colors.onPrimary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${community.members} ${community.members == 1 ? "member" : "members"}',
                      style: context.textTheme.titleSmall
                          ?.copyWith(color: context.colors.onPrimary),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () =>
                          context.go('/community/details', extra: community),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('JOIN COMMUNITY'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
