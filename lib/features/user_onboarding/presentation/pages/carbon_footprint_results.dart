import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [CarbonFootPrintResults] widget shows the results of the carbon footprint
/// of the user after the user has completed the onboarding process
/// will also have recommendations on daily  tips/ topics on how to reduce the
/// carbon footprint of the user and goals the user can
/// take to reduce the carbon footprint
class CarbonFootPrintResults extends StatefulWidget {
  /// [CarbonFootPrintResults] widget shows the results of the carbon footprint
  const CarbonFootPrintResults({super.key});

  @override
  State<CarbonFootPrintResults> createState() => _CarbonFootPrintResultsState();
}

class _CarbonFootPrintResultsState extends State<CarbonFootPrintResults> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FormLayout(
        child: Column(
          children: [
            const Spacer(),
            PrimaryButton(
              text: 'Continue with Email',
              onPressed: () => context.go('/auth'),
            ),
            PrimaryButton(text: 'Continue with Google', onPressed: () {}),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
