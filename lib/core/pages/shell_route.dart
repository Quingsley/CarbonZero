import 'package:carbon_zero/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// [TabShellRoute] is used to wrap the tabs of the application
/// and uses go router to manage the state of the tabs
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/home.svg',
              // width: 10,
              colorFilter: ColorFilter.mode(
                AppTabs.home.index == navigationShell.currentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(.62),
                BlendMode.srcIn,
              ),
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/statistics.svg',
              // width: 10,
              colorFilter: ColorFilter.mode(
                AppTabs.statistics.index == navigationShell.currentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(.62),
                BlendMode.srcIn,
              ),
            ),
            label: 'Statistics',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/community.svg',
              // width: 10,
              colorFilter: ColorFilter.mode(
                AppTabs.community.index == navigationShell.currentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(.62),
                BlendMode.srcIn,
              ),
            ),
            label: 'Community',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/rewards.svg',
              // width: 10,
              colorFilter: ColorFilter.mode(
                AppTabs.rewards.index == navigationShell.currentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(.62),
                BlendMode.srcIn,
              ),
            ),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/settings.svg',
              // width: 10,
              colorFilter: ColorFilter.mode(
                AppTabs.settings.index == navigationShell.currentIndex
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context)
                        .colorScheme
                        .onBackground
                        .withOpacity(.62),
                BlendMode.srcIn,
              ),
            ),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
