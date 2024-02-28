import 'package:flutter/material.dart';

/// button to add activity
class AddActivityBtn extends StatelessWidget {
  /// constructor
  const AddActivityBtn(
      {required this.onPressed, required this.label, super.key,});

  /// callback for the button
  final VoidCallback onPressed;

  /// label of the button
  final String label;

  @override
  Widget build(BuildContext context) {
    return FilledButton.icon(
      onPressed: onPressed,
      icon: const Icon(Icons.add),
      label: const Text("Record today 's activity"),
    );
  }
}
