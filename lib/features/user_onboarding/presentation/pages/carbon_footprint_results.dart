import 'package:carbon_zero/algorithm.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/google_button.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// [CarbonFootPrintResults] widget shows the results of the carbon footprint
/// of the user after the user has completed the onboarding process
/// will also have recommendations on daily  tips/ topics on how to reduce the
/// carbon footprint of the user and goals the user can
/// take to reduce the carbon footprint
class CarbonFootPrintResults extends ConsumerStatefulWidget {
  /// [CarbonFootPrintResults] widget shows the results of the carbon footprint
  const CarbonFootPrintResults({super.key});

  @override
  ConsumerState<CarbonFootPrintResults> createState() =>
      _CarbonFootPrintResultsState();
}

class _CarbonFootPrintResultsState
    extends ConsumerState<CarbonFootPrintResults> {
  @override
  void initState() {
    super.initState();
    results();
  }

  double? footPrint;
  Future<void> results() async {
    final personality = ref.read(personalityProvider);
    final numOfPeople = ref.read(numOfPeopleProvider);
    final dietType = ref.read(dietTypeProvider);
    final modeOfTransport = ref.read(modeOfTransportProvider);
    final flightHours = ref.read(flightHoursProvider);
    final country = ref.read(selectedCountryProvider);
    final energyConsumption = ref.read(energyConsumptionProvider);
    final isRecyclingAluminum = ref.read(aluminumProvider);
    final isRecyclingNewsPaper = ref.read(newsPaperProvider);

    final result = await getUserFootPrint(
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
    setState(() {
      footPrint = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FormLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Carbon Footprint is: $footPrint kgCO2e/year'),
            TextButton(onPressed: results, child: const Text('Press')),
            const Spacer(),
            PrimaryButton(
              text: 'Continue with Email',
              onPressed: () => context.go('/auth'),
            ),
            const GButton(
              text: 'Continue with Google',
              isLogin: false,
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
