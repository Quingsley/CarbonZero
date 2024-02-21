import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';

/// BoxImage has a container with a background image
class BoxImage extends StatelessWidget {
  /// BoxImage has a container with a background image
  const BoxImage({required this.path, super.key});

  /// path to the image
  final String path;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: context.colors.primary,
        borderRadius: BorderRadius.circular(10),
        image: DecorationImage(
          fit: BoxFit.contain,
          image: AssetImage(
            path,
          ),
        ),
      ),
    );
  }
}
