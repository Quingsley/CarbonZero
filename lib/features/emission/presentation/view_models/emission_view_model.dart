import 'dart:async';

import 'package:carbon_zero/algorithm.dart';
import 'package:carbon_zero/core/utils/food_emission_utils.dart';
import 'package:carbon_zero/features/emission/data/models/emission_model.dart';
import 'package:carbon_zero/features/emission/data/repository/emission_repository.dart';
import 'package:carbon_zero/features/emission/presentation/providers/food_emission_providers.dart';
import 'package:carbon_zero/features/emission/presentation/providers/transport_emission_providers.dart';
import 'package:carbon_zero/routes/app_routes.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// emission view model to be used by UI
class EmissionViewModel extends AsyncNotifier<void> {
  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }

  /// record food emission
  Future<void> recordFoodEmission(EmissionType type, String userId) async {
    // food data
    final mealCount = ref.read(mealCountProvider);
    final foodEmissionList = ref.read(foodEmissionListProvider);
    final selectedMeals =
        foodEmissionList.where((food) => food.isSelected).toList();

// transport data
    final mode = ref.read(selectedModeProvider);
    final hoursTraveled = ref.read(hoursTakenProvider);
    final distanceTraveled = ref.read(distanceCoveredProvider);

    final totalEmission = type == EmissionType.food
        ? calculateFoodEmission(selectedMeals, mealCount)
        : calculateTransportEmission(mode!, hoursTraveled, distanceTraveled);

    final repo = ref.read(emissionRecordingRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => repo.recordEmission(type, userId, totalEmission),
    );
    if (type == EmissionType.food) {
      ref.read(foodEmissionListProvider.notifier).state = [
        for (final food in foodEmissionList) food.copyWith(isSelected: false),
      ];
      ref.read(mealCountProvider.notifier).state = 1;
    } else {
      ref.read(selectedModeProvider.notifier).state = null;
      ref.read(hoursTakenProvider.notifier).state = 0;
      ref.read(distanceCoveredProvider.notifier).state = 0;
    }
    ref.read(AppRoutes.router).pop();
  }
}

/// emission view model provider
final emissionViewModelProvider =
    AsyncNotifierProvider<EmissionViewModel, void>(EmissionViewModel.new);
