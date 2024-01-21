import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/widgets/bottom_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [TabShellRoute] is used to wrap
class TabShellRoute extends StatelessWidget {
  /// constructor call
  const TabShellRoute({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('ShellRoute'));

  /// Widget for managing the state of a [StatefulShellRoute]
  final StatefulNavigationShell navigationShell;

  /// name of  shell [route]
  static const String route = '/shell';

  /// method used to navigate between different branches in th shell
  void _goBranch(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomAppBar(
        color: Theme.of(context).colorScheme.surface,
        height: 70,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            BottomBarItem(
              onPressed: () => _goBranch(AppTabs.home.index),
              label: 'Home',
              isSelected: AppTabs.home.index == navigationShell.currentIndex,
              iconPath: 'assets/images/home.svg',
            ),
            BottomBarItem(
              onPressed: () => _goBranch(AppTabs.statistics.index),
              label: 'Statistics',
              isSelected:
                  AppTabs.statistics.index == navigationShell.currentIndex,
              iconPath: 'assets/images/statistics.svg',
            ),
            BottomBarItem(
              onPressed: () => _goBranch(AppTabs.community.index),
              label: 'Community',
              isSelected:
                  AppTabs.community.index == navigationShell.currentIndex,
              iconPath: 'assets/images/community.svg',
            ),
            BottomBarItem(
              onPressed: () => _goBranch(AppTabs.community.index),
              label: 'Rewards',
              isSelected: AppTabs.rewards.index == navigationShell.currentIndex,
              iconPath: 'assets/images/rewards.svg',
            ),
            BottomBarItem(
              onPressed: () => _goBranch(AppTabs.settings.index),
              label: 'Settings',
              isSelected:
                  AppTabs.settings.index == navigationShell.currentIndex,
              iconPath: 'assets/images/settings.svg',
            ),
          ],
        ),
      ),
    );
  }
}
