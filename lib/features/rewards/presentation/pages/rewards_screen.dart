import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/rewards/presentation/widgets/redeem_card.dart';
import 'package:carbon_zero/features/rewards/presentation/widgets/reward_progress_card.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';

/// will show the carbon rewards  of the user
class RewardsScreen extends StatelessWidget {
  /// constructor call
  const RewardsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                        25.toString(),
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
              'Ongoing goals',
              style: context.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Expanded(
              flex: 3,
              child: ListView(
                children: const [
                  RewardProgressCard(
                    image: 'assets/images/food.png',
                    goalName: 'Meatless Month',
                    progress: 20,
                    participants: 500,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  RewardProgressCard(
                    image: 'assets/images/bike.png',
                    goalName: 'Bike ride for a week',
                    progress: 77,
                    participants: 200,
                  ),
                  Divider(
                    thickness: 2,
                  ),
                  RewardProgressCard(
                    image: 'assets/images/cans.png',
                    goalName: 'Recycling sprint',
                    progress: 7,
                    participants: 200,
                  ),
                ],
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
