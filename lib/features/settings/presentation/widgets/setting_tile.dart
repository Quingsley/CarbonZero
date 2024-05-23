import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// settings tile
class SettingsTile extends StatelessWidget {
  /// constructor call
  const SettingsTile({
    required this.title,
    required this.onTap,
    required this.icon,
    required this.iconColor,
    super.key,
    this.fillColor,
  });

  /// title
  final String title;

  /// on tap
  final VoidCallback onTap;

  /// icon
  final Widget icon;

  /// icon color
  final Color iconColor;

  /// fill color
  final Color? fillColor;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: EdgeInsets.zero,
        leading: IconButton.filledTonal(
          style: ButtonStyle(
            backgroundColor: WidgetStatePropertyAll<Color?>(fillColor),
            shape: WidgetStatePropertyAll(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          onPressed: onTap,
          color: iconColor,
          icon: icon,
        ),
        title: Text(
          title,
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: Colors.grey[600],
        ),
      ),
    );
  }
}
