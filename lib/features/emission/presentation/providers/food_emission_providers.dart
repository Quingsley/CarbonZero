import 'package:flutter_riverpod/flutter_riverpod.dart';

/// meal count provider
final mealCountProvider = StateProvider<int>((ref) {
  return 1;
});

/// current tab provider
final currentTabProvider = StateProvider<int>((ref) {
  return 0;
});
