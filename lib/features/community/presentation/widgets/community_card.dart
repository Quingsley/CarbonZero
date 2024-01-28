import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// community card widget used to display a community
/// in the community screen
class CommunityCard extends StatelessWidget {
  /// constructor call
  const CommunityCard({
    required this.image,
    required this.name,
    required this.members,
    required this.tags,
    this.description,
    super.key,
  });

  /// profile picture of the community
  final String image;

  /// name of the community
  final String name;

  /// description of the community
  final String? description;

  /// number of members in the community
  final int members;

  /// tags of the community
  final List<String> tags;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: AssetImage(image),
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
                  name,
                  style: context.textTheme.titleMedium?.copyWith(
                    color: context.colors.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (description != null) const SizedBox(height: 4),
                if (description != null)
                  Text(
                    description!,
                    style: context.textTheme.titleSmall
                        ?.copyWith(color: context.colors.onPrimary),
                  ),
                const SizedBox(width: 6),
                Text(
                  tags.join(', '),
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
                      '$members members',
                      style: context.textTheme.titleSmall
                          ?.copyWith(color: context.colors.onPrimary),
                    ),
                    const Spacer(),
                    ElevatedButton(
                      onPressed: () => context.go('/community/details'),
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
