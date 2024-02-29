import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/utils/food_emission_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// MealTitle widget
class MealTitle extends ConsumerWidget {
  /// MealTitle constructor
  const MealTitle({
    required this.type,
    super.key,
  });

  /// text
  final FoodType type;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: [
        Text(
          type.label,
          style: context.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),
        TextButton(
          onPressed: () {
            ref.read(foodEmissionListProvider.notifier).state = ref
                .read(foodEmissionListProvider)
                .map(
                  (e) => e.type == type ? e.copyWith(isSelected: true) : e,
                )
                .toList();
          },
          child: const Text(
            'Select All',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}
