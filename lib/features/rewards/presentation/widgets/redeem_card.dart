import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// will show the redeem points that are
/// available to the user
class RedeemCard extends StatelessWidget {
  /// constructor call
  const RedeemCard({required this.enabled, required this.points, super.key});

  /// whether the points are redeemable
  final bool enabled;

  /// the points that are redeemable
  final int points;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 100,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: context.colors.tertiary.withOpacity(.82),
        image: enabled
            ? const DecorationImage(
                image: AssetImage('assets/images/reedim.png'),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            points.toString(),
            style: context.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: context.colors.onPrimary,
            ),
          ),
          Text(
            'Redeem now',
            textAlign: TextAlign.center,
            style: context.textTheme.titleSmall?.copyWith(
              color: context.colors.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
