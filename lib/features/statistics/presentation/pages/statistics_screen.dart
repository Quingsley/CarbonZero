import 'package:carbon_zero/features/statistics/presentation/widgets/statistcs_card.dart';
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
      body: const Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
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
            SizedBox(
              height: 8,
            ),
            Row(
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
          ],
        ),
      ),
    );
  }
}
