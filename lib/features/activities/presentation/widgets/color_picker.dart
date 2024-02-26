import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/activities/presentation/providers/activities_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// widget used to select the color of the
/// activity or goal
class ColorPicker extends ConsumerWidget {
  /// widget used to select the color of the
  /// activity or goal
  const ColorPicker({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(selectedColorProvider);
    final isDark = ref.watch(isDarkModeStateProvider);
    return SizedBox(
      height: 500,
      child: GridView.builder(
        itemCount: ecoFriendlyColors.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 7,
          crossAxisSpacing: 2,
          mainAxisSpacing: 2,
        ),
        itemBuilder: (context, index) {
          return ClipRRect(
            borderRadius: BorderRadius.circular(50),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: InkWell(
              splashFactory: NoSplash.splashFactory,
              onTap: () {
                ref.read(selectedColorProvider.notifier).state =
                    ecoFriendlyColors[index];
              },
              child: Material(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: (color != null && color == ecoFriendlyColors[index])
                      ? BorderSide(
                          color:
                              isDark ? context.colors.secondary : Colors.black,
                        )
                      : BorderSide.none,
                ),
                child: ColoredBox(
                  color: Color(ecoFriendlyColors[index]),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: ColoredBox(
                        color:
                            color != null && color == ecoFriendlyColors[index]
                                ? Colors.black
                                : Color(ecoFriendlyColors[index]),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

/// eco friendly colors
List<int> ecoFriendlyColors = [
  0xff2E8B57, // Sea Green
  0xff3CB371, // Medium Sea Green
  0xff228B22, // Forest Green
  0xff20B2AA, // Light Sea Green
  0xff32CD32, // Lime Green
  0xff8FBC8F, // Dark Sea Green
  0xff66CDAA, // Medium Aquamarine
  0xff7FFFD4, // Aquamarine
  0xff00CED1, // Dark Turquoise
  0xff48D1CC, // Medium Turquoise
  0xff00FF7F, // Spring Green
  0xff7CFC00, // Lawn Green
  0xff98FB98, // Pale Green
  0xff00FA9A, // Medium Spring Green
  0xffADFF2F, // Green Yellow
  0xff9ACD32, // Yellow Green
  0xff6B8E23, // Olive Drab
  0xff556B2F, // Dark Olive Green
  0xffB0E0E6, // Powder Blue
  0xffADD8E6, // Light Blue
  0xff87CEEB, // Sky Blue
  Colors.red.value, // Red
  Colors.redAccent.value, // Red Accent
  Colors.yellow.value, // Yellow
  Colors.yellowAccent.value, // Yellow Accent
  Colors.green.value, // Green
  Colors.greenAccent.value, // Green Accent
  Colors.blue.value, // Blue
  Colors.blueAccent.value, // Blue Accent
  Colors.purple.value, // Purple
  Colors.purpleAccent.value, // Purple Accent
  Colors.pink.value, // Pink
  Colors.pinkAccent.value, // Pink Accent
  Colors.orange.value, // Orange
  Colors.orangeAccent.value, // Orange Accent
  Colors.teal.value, // Teal
  Colors.tealAccent.value, // Teal Accent
  Colors.indigo.value, // Indigo
  Colors.indigoAccent.value, // Indigo Accent
  Colors.cyan.value, // Cyan
  Colors.cyanAccent.value, // Cyan Accent
  Colors.amberAccent.value, // Amber Accent
  Colors.amber.value, // Amber
];
