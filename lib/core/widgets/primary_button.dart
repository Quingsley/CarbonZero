import 'package:flutter/material.dart';

/// [PrimaryButton] widget of the app.
class PrimaryButton extends StatelessWidget {
  /// Create const instance of [PrimaryButton] widget.
  const PrimaryButton({required this.text, required this.onPressed, super.key});

  /// Button text.
  final String text;

  /// Button onPressed callback.
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      color: Theme.of(context).colorScheme.primary,
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: Theme.of(context).colorScheme.onPrimary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
