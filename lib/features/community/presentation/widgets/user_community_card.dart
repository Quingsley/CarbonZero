import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// shows the users communities with the button to continue chatting
class UserCommunityCard extends StatelessWidget {
  /// constructor call
  const UserCommunityCard({
    required this.title,
    required this.image,
    required this.members,
    super.key,
  });

  /// name of the community
  final String title;

  /// profile picture of the community
  final String image;

  /// number of members in the community
  final int members;
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
              image: AssetImage(image),
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
                title,
                style: context.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 6,
              ),
              Chip(
                avatar: const Icon(Icons.people_alt),
                label: Text('$members members'),
                labelPadding: EdgeInsets.zero,
                side: BorderSide.none,
              ),
              // const Spacer(),
              OutlinedButton(
                onPressed: () {},
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
