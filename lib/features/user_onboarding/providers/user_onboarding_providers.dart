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

/// hold the value of the number of people in the household
final numOfPeopleProvider = StateProvider<int>((ref) {
  return 1;
});

/// hold the state of the selected diet type
final dietTypeProvider = StateProvider<DietType?>((ref) {
  return null;
});

/// will hold the value of the distance traveled for each mode of transport
final modeOfTransportProvider = StateProvider<Map<ModeOfTransport, int>>((ref) {
  return {
    ModeOfTransport.bev: 0,
    ModeOfTransport.bus: 0,
    ModeOfTransport.ferry: 0,
    ModeOfTransport.shortFlight: 0,
    ModeOfTransport.mediumFlight: 0,
    ModeOfTransport.gasolineCar: 0,
    ModeOfTransport.hybridEV: 0,
    ModeOfTransport.internationalRail: 0,
    ModeOfTransport.nationalRail: 0,
    ModeOfTransport.phev: 0,
    ModeOfTransport.mediumEV: 0,
    ModeOfTransport.mediumCarDiesel: 0,
    ModeOfTransport.mediumCarGasoline: 0,
  };
});

/// flight hours state provider
final flightHoursProvider = StateProvider<Map<ModeOfTransport, int>>((ref) {
  return {
    ModeOfTransport.mediumFlight: 0,
    ModeOfTransport.shortFlight: 0,
  };
});

/// hold the values of the different energy consumption types
final energyConsumptionProvider =
    StateProvider<Map<EnergyConsumptionType, double>>((ref) {
  return {
    EnergyConsumptionType.electricity: 0,
    EnergyConsumptionType.lpg: 0,
    EnergyConsumptionType.wood: 0,
    EnergyConsumptionType.gas: 0,
    EnergyConsumptionType.heatingOil: 0,
  };
});

/// hold the value of the flag if the user recycles newspapers
final newsPaperProvider = StateProvider<bool>((ref) {
  return false;
});

/// hold the value of the flag if the user recycles aluminum
final aluminumProvider = StateProvider<bool>((ref) {
  return false;
});
