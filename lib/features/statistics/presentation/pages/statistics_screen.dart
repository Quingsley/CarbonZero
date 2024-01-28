import 'package:carbon_zero/features/statistics/presentation/widgets/activity_progress_card.dart';
import 'package:carbon_zero/features/statistics/presentation/widgets/bar_chart.dart';
import 'package:carbon_zero/features/statistics/presentation/widgets/statistics_card.dart';
import 'package:flutter/material.dart';

/// will show the users statistics of their carbon footprint
class StatisticsScreen extends StatelessWidget {
  /// constructor call
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Statistics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text.rich(
              TextSpan(
                text: 'Average Footprint: ',
                children: [
                  TextSpan(
                    text: '18979kg',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: StatisticsCard(
                    type: 'Land',
                    averageFootPrint: '150',
                    icon: Icons.landscape,
                  ),
                ),
                Expanded(
                  child: StatisticsCard(
                    type: 'Water',
                    averageFootPrint: '100',
                    icon: Icons.waves,
                  ),
                ),
                Expanded(
                  child: StatisticsCard(
                    type: 'Energy',
                    averageFootPrint: '15',
                    icon: Icons.flash_on_outlined,
                  ),
                ),
                Expanded(
                  child: StatisticsCard(
                    type: 'Co2',
                    averageFootPrint: '209',
                    icon: Icons.cloud_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            const Text('CO2 Statistics'),
            const SizedBox(
              height: 16,
            ),
            const SizedBox(
              height: 150,
              child: Carbon2StatsBarChart(),
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: ListView(
                children: const [
                  Text('Activities'),
                  // WIll make them dynamic later just
                  ActivityProgressCard(
                    activityName: 'Electric Car',
                    icon: Icons.electric_car,
                    progress: '40',
                    color: Colors.redAccent,
                  ),
                  ActivityProgressCard(
                    activityName: 'Recycling',
                    icon: Icons.recycling,
                    progress: '85',
                    color: Colors.green,
                  ),
                  ActivityProgressCard(
                    activityName: 'Biking',
                    icon: Icons.bike_scooter,
                    progress: '70',
                    color: Colors.amber,
                  ),
                  ActivityProgressCard(
                    activityName: 'Recycling',
                    icon: Icons.water_drop_outlined,
                    progress: '50',
                    color: Colors.blueAccent,
                  ),
                  ActivityProgressCard(
                    activityName: 'Reusable waste bags',
                    icon: Icons.shopping_bag_outlined,
                    progress: '65',
                    color: Colors.red,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
