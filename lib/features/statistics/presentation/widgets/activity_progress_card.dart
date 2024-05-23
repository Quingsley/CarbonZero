import 'package:carbon_zero/features/activities/data/models/activity_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// will show the progress of the activity performed
class ActivityProgressCard extends StatelessWidget {
  /// constructor call
  const ActivityProgressCard({
    required this.activityModel,
    super.key,
  });

  /// activity model
  final ActivityModel activityModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => context.push('/activity-details', extra: activityModel),
      contentPadding: EdgeInsets.zero,
      leading: IconButton.filled(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(
            Color(activityModel.color).withOpacity(.52),
          ),
          minimumSize: WidgetStateProperty.all<Size>(const Size(20, 20)),
        ),
        color: Color(activityModel.color),
        icon: Text(activityModel.icon),
        onPressed: () {},
      ),
      title: Text(activityModel.name),
      subtitle: LinearProgressIndicator(
        minHeight: 10,
        borderRadius: BorderRadius.circular(12),
        value: activityModel.progress,
        backgroundColor: Colors.grey[300],
        valueColor: AlwaysStoppedAnimation<Color>(Color(activityModel.color)),
      ),
      trailing: Text('${((activityModel.progress) * 100).toStringAsFixed(2)}%'),
    );
  }
}
