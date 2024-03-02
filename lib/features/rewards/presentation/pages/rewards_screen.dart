import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/rewards/presentation/widgets/redeem_card.dart';
import 'package:carbon_zero/features/rewards/presentation/widgets/reward_progress_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:flutter_svg/flutter_svg.dart';

/// will show the carbon rewards  of the user
class RewardsScreen extends ConsumerWidget {
  /// constructor call
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);
    final activitiesAsyncValue = ref.watch(
      getActivitiesStreamProvider(
        (user.value?.userId, ActivityType.community),
      ),
    );
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Rewards'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SvgPicture.asset(
                  //   'assets/images/coin.svg',
                  //   width: 50,
                  //   height: 50,
                  //   colorFilter: const ColorFilter.mode(
                  //     Colors.amber,
                  //     BlendMode.srcIn,
                  //   ),
                  // ),
                  IconButton.filled(
                    onPressed: () {},
                    style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(
                        Colors.amberAccent.withOpacity(.62),
                      ),
                    ),
                    icon: const Icon(Icons.attach_money),
                    color: Colors.amber,
                    iconSize: 50,
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.value?.totalCarbonPoints.toString() ?? '0',
                        style: context.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Carbon Coins',
                        style: context.textTheme.titleSmall,
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      foregroundColor: context.colors.primary,
                      side: BorderSide(
                        color: context.colors.primary,
                      ),
                    ),
                    child: const Text('History'),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 4,
            ),
            Text(
              'Ongoing Community Challenges',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              flex: 3,
              child: activitiesAsyncValue.when(
                data: (activities) {
                  if (activities.isEmpty) {
                    return const Center(
                      child: Text(
                        'You have no ongoing community challenges\nPlease join one',
                      ),
                    );
                  } else {
                    return ListView.separated(
                      itemCount: activities.length,
                      separatorBuilder: (context, index) => const Divider(
                        thickness: 2,
                      ),
                      itemBuilder: (context, index) {
                        return RewardProgressCard(
                          activityModel: activities[index],
                        );
                      },
                    );
                  }
                },
                error: (error, stackTrace) {
                  return Center(
                    child: Text(
                      error is Failure ? error.message : error.toString(),
                    ),
                  );
                },
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Text('Redeem your carbon coins'),
            Expanded(
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: List.generate(
                  4,
                  (index) => RedeemCard(
                    enabled: index == 0,
                    points: index == 0 ? 25 : 25 * (index * 2),
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
