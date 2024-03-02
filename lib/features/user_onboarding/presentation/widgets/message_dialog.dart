import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// will be used to open a   message dialog
Future<void> messageDialog(BuildContext context, String message) async {
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      content: Text(
        message,
        style: context.textTheme.bodyMedium,
        textAlign: TextAlign.start,
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    ),
  );
}
