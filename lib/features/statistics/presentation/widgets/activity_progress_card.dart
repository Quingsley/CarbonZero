import 'package:flutter/material.dart';

/// will show the progress of the activity performed
class ActivityProgressCard extends StatelessWidget {
  /// constructor call
  const ActivityProgressCard({
    required this.activityName,
    required this.icon,
    required this.progress,
    required this.color,
    super.key,
  });

  /// will show the progress of the activity performed
  final String activityName;

  /// icon of the activity
  final IconData icon;

  /// progress of the activity in %
  final String progress;

  /// color of the progress bar
  final Color color;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: IconButton.filled(
        style: ButtonStyle(
          backgroundColor:
              MaterialStateProperty.all<Color>(color.withOpacity(.52)),
          minimumSize: MaterialStateProperty.all<Size>(const Size(20, 20)),
        ),
        color: color,
        icon: Icon(icon),
        onPressed: () {},
      ),
      title: Text(activityName),
      subtitle: LinearProgressIndicator(
        minHeight: 10,
        borderRadius: BorderRadius.circular(12),
        value: double.parse(progress) / 100,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(color),
      ),
      trailing: Text('$progress%'),
    );
  }
}
