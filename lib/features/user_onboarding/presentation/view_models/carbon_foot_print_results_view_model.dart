import 'dart:async';

import 'package:carbon_zero/algorithm.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// reads the calculated carbon footprint of the user from the algorithm derived
class CarbonFootPrintViewModel extends AsyncNotifier<double?> {
  @override
  FutureOr<double?> build() {
    return null;
  }

  /// will return the footprint of the user in the last 12 months
  Future<void> getCarbonFootPrint() async {
    final personality = ref.read(personalityProvider);
    final numOfPeople = ref.read(numOfPeopleProvider);
    final dietType = ref.read(dietTypeProvider);
    final modeOfTransport = ref.read(modeOfTransportProvider);
    final flightHours = ref.read(flightHoursProvider);
    final country = ref.read(selectedCountryProvider);
    final energyConsumption = ref.read(energyConsumptionProvider);
    final isRecyclingAluminum = ref.read(aluminumProvider);
    final isRecyclingNewsPaper = ref.read(newsPaperProvider);

    state = const AsyncLoading();
    state = await AsyncValue.guard(() {
      return getUserFootPrint(
        isRecyclingAluminum: isRecyclingAluminum,
        isRecyclingNewsPaper: isRecyclingNewsPaper,
        diet: dietType!,
        personality: personality!,
        country: country!,
        numOfPeople: numOfPeople,
        modeOfTransport: modeOfTransport,
        flightHours: flightHours,
        energyConsumption: energyConsumption,
      );
    });
  }
}

/// will provide the carbon footprint of the user with the necessary states
final carbonFootPrintViewModelProvider =
    AsyncNotifierProvider<CarbonFootPrintViewModel, double?>(
  CarbonFootPrintViewModel.new,
);
