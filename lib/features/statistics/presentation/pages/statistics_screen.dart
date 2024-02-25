import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/statistics/presentation/widgets/activity_progress_card.dart';
import 'package:carbon_zero/features/statistics/presentation/widgets/bar_chart.dart';
import 'package:carbon_zero/features/statistics/presentation/widgets/statistics_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will show the users statistics of their carbon footprint
class StatisticsScreen extends ConsumerWidget {
  /// constructor call
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);
    final activitiesAsyncValue =
        ref.watch(getActivitiesStreamProvider(user.value?.userId));
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
            Text.rich(
              TextSpan(
                text: 'Average Footprint: ',
                children: [
                  TextSpan(
                    text:
                        '${user.value?.initialCarbonFootPrint.toStringAsFixed(2)} kg',
                    style: const TextStyle(
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
                    averageFootPrint: '150 M sqm saved',
                    icon: Icons.landscape,
                  ),
                ),
                Expanded(
                  child: StatisticsCard(
                    type: 'Water',
                    averageFootPrint: '3.08B saved',
                    icon: Icons.waves,
                  ),
                ),
                Expanded(
                  child: StatisticsCard(
                    type: 'Energy',
                    averageFootPrint: '15.3M KWh saved',
                    icon: Icons.flash_on_outlined,
                  ),
                ),
                Expanded(
                  child: StatisticsCard(
                    type: 'Co2',
                    averageFootPrint: '91.9M Kg saved',
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
              child: activitiesAsyncValue.when(
                data: (activities) {
                  if (activities.isEmpty) {
                    return const Center(
                      child: Text('No current activities'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: activities.length,
                      itemBuilder: (context, index) {
                        return ActivityProgressCard(
                          activityName: activities[index].name,
                          icon: activities[index].icon,
                          progress: '${(activities[index].progress / 1) * 100}',
                          color: activities[index].color,
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
          ],
        ),
      ),
    );
  }
}
