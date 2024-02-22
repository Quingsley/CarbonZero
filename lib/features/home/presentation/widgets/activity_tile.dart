import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// [ActivityTile] widget of the app.
class ActivityTile extends StatelessWidget {
  /// Create const instance of [ActivityTile] widget.
  const ActivityTile({
    required this.title,
    required this.co2Emitted,
    required this.icon,
    required this.color,
    required this.points,
    super.key,
  });

  /// Activity title.
  final String title;

  /// Activity co2Emitted.
  final String co2Emitted;

  /// Activity icon.
  final String icon;

  /// color of activity
  final int color;

  /// carbon points earned
  final int points;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: SizedBox(
        height: 30,
        width: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: Color(color),
            child: Center(
              child: Text(
                icon,
                style: context.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      title: Text(title),
      subtitle: Text(
        '$points carbon points',
        style: TextStyle(color: Colors.grey[400]),
      ),
      trailing: Text.rich(
        TextSpan(
          text: co2Emitted,
          children: [
            TextSpan(
              text: 'g CO2e',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
