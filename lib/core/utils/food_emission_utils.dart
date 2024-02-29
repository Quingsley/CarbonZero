import 'package:carbon_zero/core/constants/constants.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// FoodEmission class
class FoodEmission extends Equatable {
  /// FoodEmission constructor
  const FoodEmission({
    required this.type,
    required this.title,
    required this.value,
    this.isSelected = false,
  });

  /// category
  final FoodType type;

  /// title
  final String title;

  /// emission value
  final double value;

  /// is selected
  final bool isSelected;

  @override
  List<Object?> get props => [type, title, value, isSelected];

  /// copyWith method
  FoodEmission copyWith({
    FoodType? type,
    String? title,
    double? value,
    bool? isSelected,
  }) {
    return FoodEmission(
      type: type ?? this.type,
      title: title ?? this.title,
      value: value ?? this.value,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  bool? get stringify => true;
}

/// list of food emissions (source: https://www.statista.com/statistics/1201677/greenhouse-gas-emissions-of-major-food-products/)
final List<FoodEmission> _foodEmissionList = [
  // Meat & Fish
  const FoodEmission(
    type: FoodType.meatAndFish,
    title: 'Beef (herd)',
    value: 99.48,
  ),
  const FoodEmission(
    type: FoodType.meatAndFish,
    title: 'Beef (dairy herd)',
    value: 33.3,
  ),
  const FoodEmission(
    type: FoodType.meatAndFish,
    title: 'Lamb & Mutton',
    value: 39.72,
  ),
  const FoodEmission(
    type: FoodType.meatAndFish,
    title: 'Pig Meat',
    value: 12.1,
  ),
  const FoodEmission(
    type: FoodType.meatAndFish,
    title: 'Poultry Meat',
    value: 9.87,
  ),
  const FoodEmission(
    type: FoodType.meatAndFish,
    title: 'Fish',
    value: 12.31,
  ),
  const FoodEmission(
    type: FoodType.meatAndFish,
    title: 'Prawns',
    value: 26.87,
  ),

  // Dairy & Eggs
  const FoodEmission(
    type: FoodType.dairyAndEggs,
    title: 'Eggs',
    value: 4.64,
  ),
  const FoodEmission(
    type: FoodType.dairyAndEggs,
    title: 'Milk',
    value: 3.15,
  ),
  const FoodEmission(
    type: FoodType.dairyAndEggs,
    title: 'Cheese',
    value: 23.88,
  ),

  // Produce
  const FoodEmission(
    type: FoodType.produce,
    title: 'Rice',
    value: 4.45,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Wheat & Rye',
    value: 1.57,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Maize',
    value: 1.7,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Potatoes',
    value: 2.9,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Cane sugar',
    value: 3.2,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Oat meal',
    value: 2.5,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Beet sugar',
    value: 1.81,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Barley',
    value: 1.18,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Tomatoes',
    value: 2.09,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Other pulses',
    value: 1.79,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Peas',
    value: 1.8,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Ground nuts',
    value: 3.23,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Cassava',
    value: 1.32,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Tofu (Soybeans)',
    value: 3.16,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Other Vegetables',
    value: 0.53,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Other Fruits',
    value: 1.05,
  ),
  const FoodEmission(
    type: FoodType.produce,
    title: 'Brassicas',
    value: 0.51,
  ),

  // Drinks
  const FoodEmission(
    type: FoodType.drinks,
    title: 'Coffee',
    value: 28.53,
  ),
  const FoodEmission(
    type: FoodType.drinks,
    title: 'Wine',
    value: 1.3,
  ),
  const FoodEmission(
    type: FoodType.snacks,
    title: 'Dark Chocolate',
    value: 46.65,
  ),
];

/// will provide this data to the Ui
final foodEmissionListProvider = StateProvider<List<FoodEmission>>((ref) {
  return _foodEmissionList;
});
