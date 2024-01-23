import 'package:carbon_zero/core/extensions.dart';
import 'package:flutter/material.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

/// [CarbonFootPrintData] displays the users current footprint using
/// circular a progress bar
class CarbonFootPrintData extends StatelessWidget {
  ///constructor call
  const CarbonFootPrintData({
    super.key,
  });

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
          topLabelText: 'CO2/ Daily',
          topLabelStyle: context.textTheme.bodyMedium?.copyWith(
            color: Colors.grey[500],
            fontSize: 20,
          ),
          mainLabelStyle: context.textTheme.displayMedium?.copyWith(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
          bottomLabelText: '7200 n2c',
          bottomLabelStyle: context.textTheme.bodySmall?.copyWith(
            fontSize: 16,
          ),
          modifier: (percentage) {
            // print(percentage);
            return '5.202 Kg';
          },
        ),
      ),
      min: 10,
      max: 200,
      initialValue: 89,
    );
  }
}
