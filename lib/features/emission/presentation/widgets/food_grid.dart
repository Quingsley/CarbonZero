import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/utils/food_emission_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// grid to hold food items
class FoodGrid extends ConsumerWidget {
  /// FoodGrid constructor
  const FoodGrid({required this.items, super.key});

  /// food item and their emission data
  final List<FoodEmission> items;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverGrid(
      key: ValueKey(items.length),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
      ),
      delegate: SliverChildListDelegate.fixed(
        items
            .map(
              (item) => GestureDetector(
                onTap: () {
                  final updatedItem =
                      item.copyWith(isSelected: !item.isSelected);
                  ref.read(foodEmissionListProvider.notifier).state = ref
                      .read(foodEmissionListProvider)
                      .map(
                        (e) => e.title == updatedItem.title ? updatedItem : e,
                      )
                      .toList();
                },
                child: Card(
                  color: item.isSelected ? context.colors.primary : null,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          getFoodIcon(
                            item.title,
                          ),
                          style: context.textTheme.displaySmall,
                        ),
                        Text(
                          item.title,
                          textAlign: TextAlign.center,
                          style: context.textTheme.bodyLarge?.copyWith(
                            color: item.isSelected
                                ? context.colors.onPrimary
                                : context.colors.onSurface,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
