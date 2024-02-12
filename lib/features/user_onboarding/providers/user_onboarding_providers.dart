import 'package:carbon_zero/core/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// hold the state of the selected country
final selectedCountryProvider = StateProvider<String?>((ref) {
  return null;
});

/// maintain the current page
final currentPageProvider = StateProvider<int>((ref) {
  return 0;
});

/// hold the state of the selected personality
final personalityProvider = StateProvider<Personality?>((ref) {
  return null;
});

/// hold the state of the selected diet type
final dietTypeProvider = StateProvider<DietType?>((ref) {
  return null;
});
