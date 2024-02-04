import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/community/presentation/widgets/community_card.dart';
import 'package:carbon_zero/features/community/presentation/widgets/user_community_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// users will be able to find communities and join them
/// and have group chats with the members of the community
class CommunityScreen extends StatelessWidget {
  /// constructor call
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const border = OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.all(
        Radius.circular(12),
      ),
    );
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
            SizedBox(
              child: TextField(
                decoration: InputDecoration(
                  focusedBorder: border,
                  enabledBorder: border,
                  border: border,
                  contentPadding: EdgeInsets.zero,
                  hintText: 'Find a community',
                  filled: true,
                  fillColor: context.colors.primaryContainer.withOpacity(.62),
                  prefixIcon: Icon(
                    Icons.search,
                    color: context.colors.primary,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Top Communities',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CommunityCard(
                    image: 'assets/images/solar_energy.png',
                    name: 'Renewable Energy',
                    members: 150,
                    tags: ['#solar', '#wind', '#hydro'],
                    description:
                        'The community is focused on promoting renewable energy',
                  ),
                  CommunityCard(
                    image: 'assets/images/tree_planting.png',
                    name: 'Tree Planting',
                    members: 88,
                    tags: ['#trees', '#planting', '#nature'],
                    description:
                        'The community is focused on promoting renewable energy',
                  ),
                ],
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
              child: ListView(
                children: const [
                  UserCommunityCard(
                    title: 'Operation Trees',
                    image: 'assets/images/tree_planting.png',
                    members: 150,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  UserCommunityCard(
                    title: 'Eco',
                    image: 'assets/images/eco_leaf.png',
                    members: 500,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  UserCommunityCard(
                    title: 'Water Reduction',
                    image: 'assets/images/water_reduction.png',
                    members: 200,
                  ),
                ],
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
