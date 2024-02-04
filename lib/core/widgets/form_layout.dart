import 'package:flutter/material.dart';

/// this widget will be used by column layouts that
/// have keyboard input interactivity
class FormLayout extends StatelessWidget {
  /// this widget will be used by column layouts that
  /// have keyboard input interactivity
  const FormLayout({required this.child, super.key});

  /// should be a column widget!
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, viewportConstraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: viewportConstraints.maxHeight,
            ),
            child: IntrinsicHeight(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: child,
              ),
            ),
          ),
        );
      },
    );
  }
}
