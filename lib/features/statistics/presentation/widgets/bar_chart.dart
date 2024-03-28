import 'package:carbon_zero/core/error/failure.dart';
import 'package:carbon_zero/features/activities/presentation/view_models/activity_view_model.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/statistics/presentation/widgets/bar_chart_skeleton.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// will show the statistics of CO2 emissions based on
/// best performing activity of the day (recycling, walking, biking, reusable
/// wasted bags
/// water usage, energy usage)
class Carbon2StatsBarChart extends ConsumerWidget {
  /// constructor call
  const Carbon2StatsBarChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userStreamProvider);
    final chartData = ref.watch(chartDataFutureProvider(user.value!.userId!));
    return chartData.when(
      data: (data) {
        if (data.isEmpty) {
          return const Center(
            child: Text('No data available'),
          );
        } else {
          return BarChart(
            BarChartData(
              maxY: 100,
              minY: 0,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              titlesData: FlTitlesData(
                leftTitles: const AxisTitles(),
                rightTitles: const AxisTitles(),
                topTitles: const AxisTitles(),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    getTitlesWidget: (value, meta) {
                      final text = switch (meta.formattedValue) {
                        '0' => data[0]['date'] as String,
                        '1' => data[1]['date'] as String,
                        '2' => data[2]['date'] as String,
                        '3' => data[3]['date'] as String,
                        '4' => data[4]['date'] as String,
                        '5' => data[5]['date'] as String,
                        '6' => data[6]['date'] as String,
                        _ => '',
                      };
                      return SideTitleWidget(
                        axisSide: AxisSide.bottom,
                        child: Text(
                          text,
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                      );
                    },
                  ),
                ),
              ),
              barGroups: data
                  .map(
                    (e) => BarChartGroupData(
                      showingTooltipIndicators: const [100],
                      x: data.indexOf(e),
                      barRods: <BarChartRodData>[
                        BarChartRodData(
                          toY: (e['co2Emitted'] as int).toDouble(),
                          color: Color(e['color'] as int),
                          width: 30,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ],
                    ),
                  )
                  .toList(),
            ),
          );
        }
      },
      error: (error, _) => Center(
        child: Text(error is Failure ? error.message : error.toString()),
      ),
      loading: BarChartSkeleton.new,
    );
  }
}
