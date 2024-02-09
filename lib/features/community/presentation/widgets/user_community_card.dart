import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// shows the users communities with the button to continue chatting
class UserCommunityCard extends StatelessWidget {
  /// constructor call
  const UserCommunityCard({
    required this.community,
    super.key,
  });

  /// community model
  final CommunityModel community;
  @override
  Widget build(BuildContext context) {
    return Row(
      // mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Container(
          height: 100,
          width: 150,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              onError: (exception, stackTrace) => const SizedBox(),
              image: NetworkImage(community.posterId),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 12,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                community.name,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              Chip(
                avatar: const Icon(Icons.people_alt),
                label: Text(
                  '${community.members} ${community.members == 1 ? "member" : "members"}',
                ),
                labelPadding: EdgeInsets.zero,
                side: BorderSide.none,
              ),
              // const Spacer(),
              OutlinedButton(
                onPressed: () =>
                    context.push('/community/inbox', extra: community),
                style: OutlinedButton.styleFrom(
                  foregroundColor: context.colors.primary,
                  side: BorderSide(color: context.colors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'CONTINUE CHATTING',
                  style: context.textTheme.labelSmall?.copyWith(
                    color: context.colors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
