import 'package:flutter/material.dart';

/// will be used to open a link to the
/// explanation of why we need this information
class FooterReference extends StatelessWidget {
  /// will be used to open a link to the
  /// explanation of why we need this information
  const FooterReference({
    required this.onTap,
    super.key,
  });

  /// will be used to open a link to the
  /// explanation of why we need this information
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Text(
        'why we need this information',
        style: TextStyle(
          decoration: TextDecoration.underline,
          color: Colors.blue[600],
          decorationColor: Colors.blue[600],
        ),
      ),
    );
  }
}
