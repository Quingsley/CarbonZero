import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// [KIconButton] widget
class KIconButton extends StatelessWidget {
  /// constructor call
  const KIconButton({
    required this.icon,
    required this.label,
    super.key,
    this.onPressed,
  });

  /// onPressed handler
  final void Function()? onPressed;

  /// icon of the button
  final IconData icon;

  /// button label
  final String label;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        backgroundColor: context.colors.primary,
        foregroundColor: context.colors.onPrimary,
      ),
      onPressed: onPressed,
      icon: Icon(
        icon,
      ),
      label: Text(
        label,
        style: context.textTheme.labelSmall?.copyWith(
          color: context.colors.onPrimary,
        ),
      ),
    );
  }
}
