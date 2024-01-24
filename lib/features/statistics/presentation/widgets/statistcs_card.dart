import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// [StatisticsCard] widget of the app.
class StatisticsCard extends StatelessWidget {
  /// Create const instance of [StatisticsCard] widget.
  const StatisticsCard({
    required this.type,
    required this.averageFootPrint,
    required this.icon,
    super.key,
  });

  /// Footprint type [land, water, C02, energy].
  final String type;

  /// Card averageFootPrint.
  final String averageFootPrint;

  /// Card icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      height: 100,
      width: 80,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: context.colors.inversePrimary.withOpacity(.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Icon(
            icon,
            color: context.colors.primary,
          ),
          Text(
            averageFootPrint,
            style: context.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.primary,
            ),
          ),
          Text(
            type,
            style: TextStyle(color: context.colors.primary),
          ),
        ],
      ),
    );
  }
}
