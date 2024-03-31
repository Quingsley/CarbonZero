import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

/// [CarbonFootPrintData] displays the users current footprint using
/// circular a progress bar
class CarbonFootPrintData extends StatelessWidget {
  ///constructor call
  const CarbonFootPrintData({
    required this.value,
    required this.per,
    super.key,
  });

  /// carbon footprint of the user
  final double value;

  /// per unit of the carbon footprint
  final String per;

  @override
  Widget build(BuildContext context) {
    return SleekCircularSlider(
      appearance: CircularSliderAppearance(
        counterClockwise: true,
        angleRange: 360,
        startAngle: 200,
        size: 180,
        customWidths: CustomSliderWidths(
          progressBarWidth: 180 / 10 * .5,
          // trackWidth: 3,
          // shadowWidth: 2,
        ),
        customColors: CustomSliderColors(
          trackColor: context.colors.tertiary,
          progressBarColor: context.colors.primary,
        ),
        infoProperties: InfoProperties(
          topLabelText: 'CO2e/$per',
          topLabelStyle: context.textTheme.bodyMedium?.copyWith(
            color: context.colors.onSurface.withOpacity(.62),
            fontSize: 20,
          ),
          mainLabelStyle: context.textTheme.displaySmall?.copyWith(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          bottomLabelText: conclusion(value),
          bottomLabelStyle: context.textTheme.bodySmall?.copyWith(
            fontSize: 16,
          ),
          modifier: (val) {
            return '${val.toStringAsFixed(2)} Kg';
          },
        ),
      ),
      max: per == 'year' ? 50000 : 10000, // FIXME global average
      initialValue: value,
    );
  }
}

/// [conclusion] returns a string based on the value of the carbon footprint
String conclusion(double value) {
  if (value < 2700) {
    return ' ↘️ Very Low';
  } else if (value >= 2700 && value <= 7250) {
    return '👍 Ideal';
  } else if (value >= 7250 && value <= 10000) {
    return '🫠 Average';
  } else {
    return '📛 Bad';
  }
}
