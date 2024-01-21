import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// [BottomBarItem] represents a single menu item in the bottom navigation bar
class BottomBarItem extends StatelessWidget {
  /// constructor call
  const BottomBarItem({
    required this.onPressed,
    required this.label,
    required this.isSelected,
    required this.iconPath,
    super.key,
  });

  /// toggles the active tab
  final VoidCallback onPressed;

  /// [label] of the tab
  final String label;

  /// highlights the active tab
  final bool isSelected;

  /// icon of the tab item
  final String iconPath;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      highlightColor: Theme.of(context).colorScheme.primary.withOpacity(.2),
      splashColor: Theme.of(context).colorScheme.primary.withOpacity(.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          100,
        ),
      ),
      onPressed: onPressed,
      minWidth: 20,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SvgPicture.asset(
            iconPath,
            // width: 10,
            colorFilter: ColorFilter.mode(
              isSelected
                  ? Theme.of(context).colorScheme.primary
                  : Theme.of(context).colorScheme.onBackground.withOpacity(.62),
              BlendMode.srcIn,
            ),
          ),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context)
                          .colorScheme
                          .onBackground
                          .withOpacity(.62),
                  fontSize: 7,
                ),
          ),
        ],
      ),
    );
  }
}
