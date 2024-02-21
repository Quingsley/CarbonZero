import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/google_button.dart';
import 'package:carbon_zero/features/home/presentation/widgets/carbon_foot_print.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/view_models/carbon_foot_print_results_view_model.dart';
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
    Future.delayed(Duration.zero, () async {
      await ref
          .read(carbonFootPrintViewModelProvider.notifier)
          .getCarbonFootPrint();
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbonVm = ref.watch(carbonFootPrintViewModelProvider);
    final footPrint = carbonVm.value;
    return Scaffold(
      appBar: AppBar(),
      body: FormLayout(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarbonFootPrintData(
              value: footPrint ?? 0,
              per: 'year',
            ),
            const SizedBox(height: 10),
            Material(
              elevation: 5,
              child: Container(
                padding: const EdgeInsets.all(10),
                color: Theme.of(context).colorScheme.primary,
                child: Column(
                  children: [
                    Text(
                      'Your carbon footprint is ${footPrint ?? 0} kg CO2e per year',
                    ),
                    const Text(
                      'This is higher than the average carbon footprint of 10.5 per year',
                    ),
                    const Text(
                      'You can reduce your carbon footprint by 5% by using public transport instead of driving',
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            PrimaryButton(
              text: 'Continue with Email',
              onPressed: () => context.go('/auth/sign-up'),
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
