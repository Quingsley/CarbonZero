import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/utils/utils.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/box_image.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/footer_reference.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// Energy consumption question
class EnergyConsumptionQ extends ConsumerWidget {
  /// Energy consumption question
  const EnergyConsumptionQ({required this.controller, super.key});

  /// controller
  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final numOfPeople = ref.watch(numOfPeopleProvider);
    return FormLayout(
      applyPadding: false,
      child: Column(
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
              Expanded(
                flex: 2,
                child: Chip(label: Text(numOfPeople.toString())),
              ),
            ],
          ),
          SfSlider(
            value: numOfPeople.toDouble(),
            min: 1,
            max: 50,
            interval: 5,
            showTicks: true,
            showLabels: true,
            enableTooltip: true,
            minorTicksPerInterval: 1,
            tooltipShape: const SfPaddleTooltipShape(),
            onChanged: (val) {
              ref.read(numOfPeopleProvider.notifier).state =
                  (val as double).toInt();
            },
          ),
          const SizedBox(
            height: 10,
          ),
          // Slider(
          //   value: numOfPeople.toDouble(),
          //   min: 1,
          //   label: '$numOfPeople',
          //   divisions: 49,
          //   max: 50,
          //   onChanged: (val) {
          //     ref.read(numOfPeopleProvider.notifier).state = val.toInt();
          //   },
          // ),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * .35,
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
          Padding(
            padding: const EdgeInsets.only(top: 20),
            child: FooterReference(
              onTap: () async {
                await openCustomTab(
                  context,
                  'https://www.carbonindependent.org/15.html',
                );
              },
            ),
          ),
          PrimaryButton(
            text: 'Go Back',
            onPressed: () {
              controller.previousPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            },
          ),
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
      ),
    );
  }
}
