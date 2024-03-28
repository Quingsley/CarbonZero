import 'package:carbon_zero/features/community/data/models/community_model.dart';
import 'package:carbon_zero/features/community/presentation/widgets/user_community_card.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// skeleton when loading communities in community screen
class UserCommunityLoadingSkeleton extends StatelessWidget {
  /// constructor
  const UserCommunityLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: ListView.builder(
        itemCount: _fakeCommunities.length,
        itemBuilder: (context, index) {
          return UserCommunityCard(
            community: _fakeCommunities[index],
          );
        },
      ),
    );
  }
}

final _fakeCommunities = List.filled(
  3,
  CommunityModel(
    description: BoneMock.paragraph,
    posterId:
        'https://firebasestorage.googleapis.com/v0/b/carbonzero-53d68.appspot.com/o/broccoli.png?alt=media&token=9e755947-2a3c-4821-9abd-ee93775700b8',
    adminId: BoneMock.name,
    name: BoneMock.name,
    tags: [
      BoneMock.name,
      BoneMock.name,
    ],
    members: 20,
  ),
);
