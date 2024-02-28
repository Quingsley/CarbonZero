import 'dart:math';

import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/activities/presentation/providers/activities_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// random
final random = Random();

/// will enable user to pick an icon for the
/// selected activity
class IconPack extends ConsumerWidget {
  /// constructor call
  const IconPack({required this.icons, this.isMain = false, super.key});

  /// list of icons
  final List<String> icons;

  /// shows only featured icons
  final bool isMain;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // number of featuredIcons
    // const numberOfFeaturedIcons =14;
    // final start = random.nextInt(icons.length - numberOfFeaturedIcons);
    // final end = start + numberOfFeaturedIcons;
    // final featuredIcons = isMain ? icons.getRange(0, 14).toList();
    final selectedIcon = ref.watch(selectedIconProvider);
    final isDark = ref.watch(isDarkModeStateProvider);
    if (selectedIcon != null && isMain && icons[0] != selectedIcon) {
      icons
        ..removeAt(0)
        ..removeAt(icons.indexOf(selectedIcon))
        ..insert(0, selectedIcon);
    }
    return GridView.builder(
      itemCount: isMain ? icons.getRange(0, 14).length : icons.length,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isMain ? 7 : 9,
      ),
      itemBuilder: (context, index) => GestureDetector(
        onTap: () {
          ref.read(selectedIconProvider.notifier).state = icons[index];
        },
        child: Card(
          elevation: 3,
          color: context.colors.primary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: (selectedIcon != null && selectedIcon == icons[index])
                ? BorderSide(
                    width: 2,
                    color: isDark ? context.colors.secondary : Colors.black,
                  )
                : BorderSide.none,
          ),
          child: Center(
            child: Text(
              isMain ? icons.getRange(0, 14).toList()[index] : icons[index],
              style: context.textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }
}
