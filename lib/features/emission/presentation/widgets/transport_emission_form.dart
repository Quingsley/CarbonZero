import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/emission/presentation/providers/transport_emission_providers.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/box_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

/// will have the form to input the transport emissions
class TransportEmissionForm extends ConsumerWidget {
  /// will have the form to input the transport emissions
  const TransportEmissionForm({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final distance = ref.watch(distanceCoveredProvider);
    final hours = ref.watch(hoursTakenProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final isFlight = selectedMode == ModeOfTransport.shortFlight ||
        selectedMode == ModeOfTransport.longFlight ||
        selectedMode == ModeOfTransport.mediumFlight;
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Travel time',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          Text(
            'How much did you travel on this day?',
            style: context.textTheme.bodyLarge,
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: MediaQuery.sizeOf(context).height * 0.2,
            child: Material(
              elevation: 1,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: ModeOfTransport.values
                    .map(
                      (mode) => GestureDetector(
                        onTap: () {
                          ref.read(selectedModeProvider.notifier).state = mode;
                        },
                        child: Card(
                          color: mode == selectedMode
                              ? context.colors.primary
                              : context.colors.surface,
                          elevation: mode == selectedMode ? 10 : 1,
                          child: Center(
                            child: SizedBox(
                              width: MediaQuery.sizeOf(context).width * 0.4,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  BoxImage(path: getTransportAssetName(mode)),
                                  const SizedBox(
                                    height: 6,
                                  ),
                                  Text(
                                    mode.label,
                                    textAlign: TextAlign.center,
                                    style:
                                        context.textTheme.bodyMedium?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: mode == selectedMode
                                          ? context.colors.onPrimary
                                          : context.colors.onSurface,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            'Distance traveled in km:  $distance',
            style: context.textTheme.titleLarge,
          ),
          const SizedBox(height: 10),
          SfSlider(
            max: 22000,
            interval: 1000,
            showTicks: true,
            enableTooltip: true,
            tooltipShape: const SfPaddleTooltipShape(),
            // label: '$distance km',
            value: distance.toDouble(),
            onChanged: (val) {
              ref.read(distanceCoveredProvider.notifier).state =
                  (val as double).toInt();
            },
          ),
          if (isFlight)
            Text(
              'How many hours did your flight take?: $hours hours',
              style: context.textTheme.titleLarge,
            ),
          if (isFlight)
            SfSlider(
              max: 1000,
              interval: 100,
              // label: '$hours hours',
              value: hours.toDouble(),
              showTicks: true,
              enableTooltip: true,
              tooltipShape: const SfPaddleTooltipShape(),
              onChanged: (val) {
                ref.read(hoursTakenProvider.notifier).state =
                    (val as double).toInt();
              },
            ),
        ],
      ),
    );
  }
}
