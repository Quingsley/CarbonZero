import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/bottom_sheet.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/box_image.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/footer_reference.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Mode of transport question
class ModeOfTransportQ extends StatelessWidget {
  /// Mode of transport question
  const ModeOfTransportQ({required this.controller, super.key});

  /// controller
  final PageController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          "Let's talk about your mode of transport for the past year. How did you travel?(Can pick more than one option)",
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Expanded(
          flex: 10,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            child: ListView(
              children: ModeOfTransport.values.map(
                (mode) {
                  final isFlight = mode == ModeOfTransport.shortFlight ||
                      mode == ModeOfTransport.mediumFlight ||
                      mode == ModeOfTransport.longFlight;
                  final widgetToShow = isFlight
                      ? FlightInputQ(mode: mode)
                      : DistanceInput(mode: mode);
                  return ListTile(
                    leading: BoxImage(
                      path: getTransportAssetName(mode),
                    ),
                    title: Text(mode.label),
                    subtitle: Text('Select if you use ${mode.label}'),
                    onTap: () async {
                      await kShowBottomSheet(
                        context: context,
                        child: widgetToShow,
                        height: isFlight
                            ? MediaQuery.sizeOf(context).height * 0.55
                            : null,
                      );
                    },
                    trailing: IconButton.filledTonal(
                      style: IconButton.styleFrom(
                        backgroundColor: context.colors.tertiary,
                      ),
                      onPressed: () async {
                        await kShowBottomSheet(
                          context: context,
                          child: widgetToShow,
                          height: isFlight
                              ? MediaQuery.sizeOf(context).height * 0.55
                              : null,
                        );
                      },
                      icon: const Icon(Icons.add),
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
              curve: Curves.easeIn,
            );
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// provides a slider for selecting distance
class DistanceInput extends ConsumerStatefulWidget {
  /// provides a slider for selecting distance
  const DistanceInput({
    required this.mode,
    super.key,
  });

  /// mode of transport
  final ModeOfTransport mode;

  @override
  ConsumerState<DistanceInput> createState() => _DistanceInputState();
}

class _DistanceInputState extends ConsumerState<DistanceInput> {
  int _distance = 50;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Distance traveled in the past 12 months in KM',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: 10),
        const InfoMessage(),
        Chip(label: Text('Default Value: $_distance KM')),
        Slider(
          max: 22000,
          value: _distance.toDouble(),
          onChanged: (value) {
            setState(() {
              _distance = value.toInt();
            });
            ref.read(modeOfTransportProvider.notifier).state[widget.mode] =
                value.toInt();
          },
        ),
        PrimaryButton(
          text: 'Save',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}

/// tells user to leave default values
class InfoMessage extends StatelessWidget {
  /// tells user to leave default values
  const InfoMessage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          Icons.info,
          color: context.colors.primary,
        ),
        const SizedBox(width: 10),
        const Text('If unsure leave the default values'),
      ],
    );
  }
}

/// Flight input question
class FlightInputQ extends ConsumerStatefulWidget {
  /// Flight input question
  const FlightInputQ({required this.mode, super.key});

  /// mode of transport
  final ModeOfTransport mode;

  @override
  ConsumerState<FlightInputQ> createState() => _FlightInputQState();
}

class _FlightInputQState extends ConsumerState<FlightInputQ> {
  int _distance = 100;
  int _timeTaken = 4;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'We want to know your flight details',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        const InfoMessage(),
        Chip(label: Text('Distance traveled  $_distance KM')),
        const SizedBox(
          height: 8,
        ),
        SizedBox(
          child: Slider(
            value: _distance.toDouble(),
            min: 100,
            label: '$_distance km',
            divisions: 1000,
            max: 22000,
            onChanged: (val) {
              setState(() {
                _distance = val.toInt();
              });
              ref.read(modeOfTransportProvider.notifier).state[widget.mode] =
                  val.toInt();
            },
          ),
        ),
        const Divider(),
        Chip(label: Text('Average Hours Traveled $_timeTaken Hours')),
        SizedBox(
          child: Slider(
            value: _timeTaken.toDouble(),
            max: 1000,
            divisions: 100,
            label: '$_timeTaken Hours',
            onChanged: (val) {
              setState(() {
                _timeTaken = val.toInt();
              });
              ref.read(flightHoursProvider.notifier).state[widget.mode] =
                  val.toInt();
            },
          ),
        ),
        PrimaryButton(
          text: 'Save',
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
