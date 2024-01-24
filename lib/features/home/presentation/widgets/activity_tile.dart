import 'package:flutter/material.dart';

/// [ActivityTile] widget of the app.
class ActivityTile extends StatelessWidget {
  /// Create const instance of [ActivityTile] widget.
  const ActivityTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
    this.trailing,
  });

  /// Activity title.
  final String title;

  /// Activity subtitle.
  final String subtitle;

  /// Activity trailing.
  final String? trailing;

  /// Activity icon.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey[400]),
      ),
      trailing: Text.rich(
        TextSpan(
          text: '-500gr ',
          children: [
            TextSpan(
              text: 'Co2',
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
