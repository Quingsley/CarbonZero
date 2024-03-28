import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

/// skeleton when loading bar chart data
class BarChartSkeleton extends StatelessWidget {
  /// constructor for BarChartSkeleton widget
  const BarChartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Skeletonizer(
      child: BarChart(
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
                    '0' => 'Mon',
                    '1' => 'Tue',
                    '2' => 'Wed',
                    '3' => 'Thur',
                    '4' => 'Fri',
                    '5' => 'Sat',
                    '6' => 'Sun',
                    _ => '',
                  };
                  return SideTitleWidget(
                    axisSide: AxisSide.bottom,
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.grey.shade200,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          barGroups: _fakeData,
        ),
      ),
    );
  }
}

/// fake bar chart data

final _fakeData = List.generate(
  7,
  (index) => BarChartGroupData(
    showingTooltipIndicators: const [100],
    x: index,
    barRods: <BarChartRodData>[
      BarChartRodData(
        toY: (index + 1) * 10.0,
        color: Colors.grey.shade300,
        width: 30,
        borderRadius: BorderRadius.circular(4),
      ),
    ],
  ),
);
