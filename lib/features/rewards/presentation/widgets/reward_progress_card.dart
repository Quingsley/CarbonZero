import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// card used to show the progress of the user in the rewards section
class RewardProgressCard extends StatelessWidget {
  /// constructor call
  const RewardProgressCard({
    required this.image,
    required this.goalName,
    required this.progress,
    required this.participants,
    super.key,
  });

  /// poster of the goal
  final String image;

  /// name of the goal
  final String goalName;

  /// progress of the user in the goal
  final double progress;

  /// number of participants in the goal
  final int participants;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 120,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(
          width: 6,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              goalName,
              style: context.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            Chip(
              avatar: SvgPicture.asset(
                'assets/images/community-icon.svg',
                width: 24,
                colorFilter: ColorFilter.mode(
                  context.colors.tertiary,
                  BlendMode.srcIn,
                ),
              ),
              labelPadding: EdgeInsets.zero,
              label: Text('$participants members'),
              side: BorderSide.none,
              padding: EdgeInsets.zero,
            ),
            const SizedBox(
              height: 12,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                SizedBox(
                  width: 170,
                  child: LinearProgressIndicator(
                    value: progress / 100,
                    backgroundColor: Colors.grey.withOpacity(.62),
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(12),
                    minHeight: 8,
                  ),
                ),
                const SizedBox(
                  width: 8,
                ),
                Text('${progress.toInt()}%'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
