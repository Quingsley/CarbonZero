import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// will show the details of a community
class CommunityDetails extends StatelessWidget {
  /// constructor call
  const CommunityDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              Image.asset('assets/images/solar_energy.png'),
              Positioned(
                top: 40,
                left: 10,
                child: IconButton.filled(
                  color: context.colors.secondary,
                  iconSize: 12,
                  style: ButtonStyle(
                    padding: const MaterialStatePropertyAll(
                      EdgeInsets.zero,
                    ),
                    backgroundColor: MaterialStatePropertyAll(
                      context.colors.secondary.withOpacity(.62),
                    ),
                    shape: MaterialStatePropertyAll(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  onPressed: () => context.pop(),
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                  ),
                ),
              ),
            ],
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Renewable Energy',
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(sampleText, style: context.textTheme.labelSmall),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
