import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/utils/food_emission_utils.dart';
import 'package:carbon_zero/features/emission/presentation/providers/food_emission_providers.dart';
import 'package:carbon_zero/features/emission/presentation/widgets/food_grid.dart';
import 'package:carbon_zero/features/emission/presentation/widgets/meal_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// collect info about the users diet
class FoodEmissionForm extends ConsumerWidget {
  /// FoodEmissionForm constructor
  const FoodEmissionForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final foodEmissionList = ref.watch(foodEmissionListProvider);
    final mealCount = ref.watch(mealCountProvider);
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            Row(
              children: [
                Text(
                  'How many meals did you eat ?',
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: () {
                        if (mealCount > 1) {
                          ref.read(mealCountProvider.notifier).state--;
                        }
                      },
                    ),
                    Text('$mealCount'),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (mealCount < 3) {
                          ref.read(mealCountProvider.notifier).state++;
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              'What did you Eat, Select All that apply',
              textAlign: TextAlign.start,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
          ]),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const MealTitle(type: FoodType.dairyAndEggs),
            const SizedBox(height: 8),
          ]),
        ),
        FoodGrid(
          items: foodEmissionList
              .where((food) => food.type == FoodType.dairyAndEggs)
              .toList(),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 8),
            const MealTitle(type: FoodType.meatAndFish),
            const SizedBox(height: 8),
          ]),
        ),
        FoodGrid(
          items: foodEmissionList
              .where((food) => food.type == FoodType.meatAndFish)
              .toList(),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 8),
            const MealTitle(type: FoodType.produce),
            const SizedBox(height: 8),
          ]),
        ),
        FoodGrid(
          items: foodEmissionList
              .where((food) => food.type == FoodType.produce)
              .toList(),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 8),
            const MealTitle(type: FoodType.drinks),
            const SizedBox(height: 8),
          ]),
        ),
        FoodGrid(
          items: foodEmissionList
              .where((food) => food.type == FoodType.drinks)
              .toList(),
        ),
        SliverList(
          delegate: SliverChildListDelegate([
            const SizedBox(height: 8),
            const MealTitle(type: FoodType.snacks),
            const SizedBox(height: 8),
          ]),
        ),
        FoodGrid(
          items: foodEmissionList
              .where((food) => food.type == FoodType.snacks)
              .toList(),
        ),
      ],
    );
  }
}
