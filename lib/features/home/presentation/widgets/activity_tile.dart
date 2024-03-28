import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:carbon_zero/services/local_notifications.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [ActivityTile] widget of the app.
class ActivityTile extends StatefulWidget {
  /// Create const instance of [ActivityTile] widget.
  const ActivityTile({
    required this.activity,
    super.key,
  });

  /// The activity model.
  final ActivityModel activity;

  @override
  State<ActivityTile> createState() => _ActivityTileState();
}

class _ActivityTileState extends State<ActivityTile> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await NotificationController.scheduleNotification(
        widget.activity,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push('/activity-details', extra: widget.activity),
      leading: SizedBox(
        height: 30,
        width: 30,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: ColoredBox(
            color: Color(widget.activity.color),
            child: Center(
              child: Text(
                widget.activity.icon,
                style: context.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
      title: Text(widget.activity.name),
      subtitle: Text(
        '${widget.activity.carbonPoints} carbon points',
        style: TextStyle(color: Colors.grey[400]),
      ),
      trailing: Text.rich(
        TextSpan(
          text: widget.activity.cO2Emitted.toString(),
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
