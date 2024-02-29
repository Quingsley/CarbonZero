import 'package:flutter_riverpod/flutter_riverpod.dart';

/// meal count provider
final mealCountProvider = StateProvider<int>((ref) {
  return 1;
});
