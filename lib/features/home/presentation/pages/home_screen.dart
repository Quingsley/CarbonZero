import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/home/presentation/widgets/activity_tile.dart';
import 'package:carbon_zero/features/home/presentation/widgets/carbon_foot_print.dart';
import 'package:carbon_zero/features/home/presentation/widgets/home_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [HomeScreen] the home tab of the app contains activities like
/// the carbon footprint of the user, daily goals, community goal daily tip ,
///  latest activities
class HomeScreen extends StatefulWidget {
  /// constructor call
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isDay = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    isDaytime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                RichText(
                  text: TextSpan(
                    style: context.textTheme.headlineSmall?.copyWith(
                      color: context.colors.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    text: 'Hi ',
                    children: [
                      TextSpan(
                        text: 'Jane ',
                        style: context.textTheme.headlineMedium?.copyWith(
                          color: context.colors.primary,
                        ),
                      ),
                      WidgetSpan(
                        child: AnimatedCrossFade(
                          duration: const Duration(seconds: 1),
                          crossFadeState: isDay
                              ? CrossFadeState.showFirst
                              : CrossFadeState.showSecond,
                          sizeCurve: Curves.easeIn,
                          firstChild: Icon(
                            Icons.light_mode,
                            color: Colors.amberAccent.shade700,
                          ),
                          secondChild: const Icon(
                            Icons.dark_mode,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      color: context.colors.primary,
                      onPressed: () => context.push('/notification'),
                      icon: const Icon(Icons.notifications),
                    ),
                    IconButton.filled(
                      onPressed: () => context.push('/profile'),
                      icon: const Icon(Icons.person),
                    ),
                  ],
                ),
              ],
            ),
            const Text('Hope you  planted a tree today'),
            const SizedBox(
              height: 20,
            ),
            const Align(
              child: CarbonFootPrintData(),
            ),
            const SizedBox(
              height: 8,
            ),
            const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: HomeCard(
                    title: 'Reach to goal',
                    description: '9453 co2',
                    icon: Icons.line_axis,
                  ),
                ),
                Expanded(
                  child: HomeCard(
                    title: 'Community goal',
                    description: '10489 co2',
                    icon: Icons.people,
                  ),
                ),
              ],
            ),
            const HomeCard(
              title: null,
              description:
                  'Using reusable bags instead of plastic bags when shopping can help reduce carbon emmisions by reducing the amount of plastic waste produced',
              icon: Icons.lightbulb,
            ),
            Expanded(
              child: ListView(
                children: const [
                  Text(
                    'Latest activities',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  ActivityTile(
                    icon: Icons.ev_station,
                    title: '19 km electric car',
                    subtitle: '500 n2c points',
                  ),
                  ActivityTile(
                    icon: Icons.recycling,
                    title: 'Recycling',
                    subtitle: '500 n2c points',
                  ),
                  ActivityTile(
                    icon: Icons.pedal_bike,
                    title: '20km biking',
                    subtitle: '500 n2c points',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// checks  if it is day or night
  void isDaytime() {
    final now = DateTime.now();
    final currentHour = now.hour;

    // Assuming daytime is between 6 AM and 6 PM, adjust the range as needed
    setState(() {
      isDay = currentHour >= 6 && currentHour < 18;
    });
  }
}
