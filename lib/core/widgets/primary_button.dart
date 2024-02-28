import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// [PrimaryButton] widget of the app.
class PrimaryButton extends StatelessWidget {
  /// Create const instance of [PrimaryButton] widget.
  const PrimaryButton({
    required this.text,
    required this.onPressed,
    super.key,
    this.isLoading = false,
  });

  /// Button text.
  final String text;

  /// will show a loading indicator if true
  final bool isLoading;

  /// Button onPressed callback.
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        backgroundColor: context.colors.primary,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 2),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          if (isLoading)
            const SizedBox(
              width: 8,
            ),
          Text(
            text,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}
