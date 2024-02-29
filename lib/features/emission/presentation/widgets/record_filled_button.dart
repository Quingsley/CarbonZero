import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/utils/food_emission_utils.dart';
import 'package:carbon_zero/features/emission/presentation/providers/transport_emission_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// RecordFilledButton widget
class RecordFilledButton extends ConsumerWidget {
  /// RecordFilledButton constructor
  const RecordFilledButton({
    required this.text,
    required this.onPressed,
    required this.isLoading,
    required this.currentTabIndex,
    super.key,
  });

  /// text of the button
  final String text;

  /// onPressed
  final VoidCallback onPressed;

  /// isLoading
  final bool isLoading;

  /// current tab index
  final int currentTabIndex;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedFoods = ref.watch(foodEmissionListProvider);
    final selectedMode = ref.watch(selectedModeProvider);
    final distance = ref.watch(distanceCoveredProvider);
    final hours = ref.watch(hoursTakenProvider);
    final isFlight = selectedMode == ModeOfTransport.shortFlight ||
        selectedMode == ModeOfTransport.longFlight ||
        selectedMode == ModeOfTransport.mediumFlight;
    final isDisabled = currentTabIndex == 0
        ? selectedFoods.every((element) => !element.isSelected)
        : (selectedMode == null || distance == 0 || (isFlight && hours == 0));

    return FilledButton(
      style: FilledButton.styleFrom(
        fixedSize: Size(
          MediaQuery.sizeOf(context).width * .8,
          MediaQuery.sizeOf(context).height * .08,
        ),
      ),
      onPressed: !isLoading
          ? isDisabled
              ? null
              : onPressed
          : null,
      child: !isLoading
          ? Text(
              text,
              style: context.textTheme.titleLarge?.copyWith(
                color: context.colors.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            )
          : const CircularProgressIndicator(),
    );
  }
}
