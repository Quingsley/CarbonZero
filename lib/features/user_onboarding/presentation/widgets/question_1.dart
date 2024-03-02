import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/utils/utils.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/footer_reference.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// requires user to select country he has been living for the last 12 months
class CountryQ extends ConsumerWidget {
  /// requires user to select country he has been living for the last 12 months
  const CountryQ({required this.controller, super.key});

  /// page controller
  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCountry = ref.watch(selectedCountryProvider);
    return Column(
      children: [
        Text(
          "Let's get to know you better",
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(
          height: 20,
        ),
        Text(
          'Which country have you been living for the last 12 months?',
          style: context.textTheme.titleMedium,
        ),
        const SizedBox(
          height: 100,
        ),
        Center(
          child: FilledButton(
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
              fixedSize: const Size(200, 50),
            ),
            onPressed: () {
              showCountryPicker(
                context: context,
                useRootNavigator: true,
                countryListTheme: CountryListThemeData(
                  backgroundColor: context.colors.primaryContainer,
                ),
                onSelect: (Country country) {
                  ref.read(selectedCountryProvider.notifier).state =
                      '${country.flagEmoji} ${country.displayNameNoCountryCode}';
                },
              );
            },
            child: Text(selectedCountry ?? 'Select country'),
          ),
        ),
        const Spacer(),
        FooterReference(
          onTap: () async {
            await openCustomTab(
              context,
              'https://ourworldindata.org/co2-emissions#per-capita-co2-emissions',
            );
          },
        ),
        const SizedBox(height: 4),
        PrimaryButton(
          text: 'Continue',
          onPressed: selectedCountry == null
              ? null
              : () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
