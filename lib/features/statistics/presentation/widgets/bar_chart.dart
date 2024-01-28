import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

/// will show the statistics of CO2 emissions based on
/// best performing activity of the day (recycling, walking, biking, reusable
/// wasted bags
/// water usage, energy usage)
class Carbon2StatsBarChart extends StatelessWidget {
  /// constructor call
  const Carbon2StatsBarChart({super.key});

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        maxY: 200,
        minY: 20,
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
                  '0' => 'M',
                  '1' => 'T',
                  '2' => 'W',
                  '3' => 'T',
                  '4' => 'F',
                  '5' => 'S',
                  '6' => 'S',
                  String() => '',
                };
                return Text(
                  text,
                  style: TextStyle(color: Colors.grey[400]),
                );
              },
            ),
          ),
        ),
        barGroups: <BarChartGroupData>[
          BarChartGroupData(
            showingTooltipIndicators: const [100],
            x: 0,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: 100,
                color: Colors.green,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 1,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: 150,
                color: Colors.red,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 2,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: 77,
                color: Colors.redAccent,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 3,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: 200,
                color: Colors.blue,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 4,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: 200,
                color: Colors.amber,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          BarChartGroupData(
            x: 5,
            barRods: <BarChartRodData>[
              BarChartRodData(
                toY: 200,
                color: Colors.deepPurple,
                width: 30,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
