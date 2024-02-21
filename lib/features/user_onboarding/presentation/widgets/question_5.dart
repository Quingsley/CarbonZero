import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/box_image.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/footer_reference.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

/// Energy consumption question
class EnergyConsumptionQ extends ConsumerWidget {
  /// Energy consumption question
  const EnergyConsumptionQ({required this.controller, super.key});

  /// controller
  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numOfPeople = ref.watch(numOfPeopleProvider);
    return Column(
      children: [
        Text(
          'Tell us about your household energy consumption for the last 12 months.',
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              flex: 3,
              child: Text(
                'How many people live in your household?',
                style: context.textTheme.titleSmall,
                textAlign: TextAlign.start,
              ),
            ),
            Expanded(flex: 2, child: Chip(label: Text(numOfPeople.toString()))),
          ],
        ),
        Slider(
          value: numOfPeople.toDouble(),
          min: 1,
          divisions: 49,
          max: 50,
          onChanged: (val) {
            ref.read(numOfPeopleProvider.notifier).state = val.toInt();
          },
        ),
        Expanded(
          flex: 8,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListView(
              children: EnergyConsumptionType.values.map(
                (e) {
                  final unit = e == EnergyConsumptionType.wood
                      ? 'Tonnes'
                      : e == EnergyConsumptionType.lpg ||
                              e == EnergyConsumptionType.gas
                          ? 'Kg'
                          : e == EnergyConsumptionType.heatingOil
                              ? 'litres'
                              : 'KWh';
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: ListTile(
                      leading: BoxImage(path: getEnergyAsset(e)),
                      title: Text(e.label),
                      trailing: SizedBox(
                        width: 120,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SizedBox(
                              width: 80,
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  filled: true,
                                  border: const OutlineInputBorder(),
                                  enabledBorder: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: context.colors.primary,
                                    ),
                                  ),
                                ),
                                onFieldSubmitted: (value) {
                                  if (value.trim().isNotEmpty) {
                                    ref
                                        .read(
                                          energyConsumptionProvider.notifier,
                                        )
                                        .state[e] = double.parse(value);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 5),
                            Expanded(
                              child: Text(
                                unit,
                                style: context.textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ),
        const Spacer(),
        FooterReference(onTap: () {}),
        PrimaryButton(
          text: 'Continue',
          onPressed: () {
            controller.nextPage(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
