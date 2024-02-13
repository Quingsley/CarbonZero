import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/google_button.dart';
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
