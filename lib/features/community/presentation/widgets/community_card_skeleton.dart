import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/widgets/community_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// skeleton when loading communities in community screen
class CommunityLoadingSkeleton extends StatelessWidget {
  /// constructor
  const CommunityLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _fakeCommunities.length,
        itemBuilder: (context, index) {
          return CommunityCard(
            community: _fakeCommunities[index],
          );
        },
      ),
    );
  }
}

final _fakeCommunities = List.filled(
  4,
  CommunityModel(
    description: BoneMock.paragraph,
    posterId: BoneMock.name,
    adminId: BoneMock.name,
    name: BoneMock.name,
    tags: [
      BoneMock.name,
      BoneMock.name,
    ],
    members: 20,
  ),
);
