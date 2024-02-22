import 'package:flutter_riverpod/flutter_riverpod.dart';

/// holds the value of the selectedIcon
final selectedIconProvider = StateProvider<String?>((ref) => null);

/// holds the value of the selected color
final selectedColorProvider = StateProvider<int?>((ref) {
  return null;
});
