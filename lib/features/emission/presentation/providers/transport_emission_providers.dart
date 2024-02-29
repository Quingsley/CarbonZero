import 'package:carbon_zero/core/constants/constants.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [distanceCoveredProvider] will provide the distance covered by the user
final distanceCoveredProvider = StateProvider<int>((ref) {
  return 0;
});

/// [hoursTakenProvider] will provide the total hours of the flight
final hoursTakenProvider = StateProvider<int>((ref) {
  return 0;
});

/// [selectedModeProvider] will provide the mode of transport
/// selected by the user
final selectedModeProvider = StateProvider<ModeOfTransport?>((ref) {
  return null;
});
