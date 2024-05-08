import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/services/local_notifications.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// [TabShellRoute] is used to wrap the tabs of the application
/// and uses go router to manage the state of the tabs
class TabShellRoute extends ConsumerStatefulWidget {
  /// constructor call
  const TabShellRoute({required this.navigationShell, Key? key})
      : super(key: key ?? const ValueKey<String>('ShellRoute'));

  /// Widget for managing the state of a [StatefulShellRoute]
  final StatefulNavigationShell navigationShell;

  /// name of  shell [route]
  static const String route = '/shell';

  @override
  ConsumerState<TabShellRoute> createState() => _TabShellRouteState();
}

class _TabShellRouteState extends ConsumerState<TabShellRoute> {
  late int _currentPageIndex;

  @override
  void initState() {
    super.initState();
    _currentPageIndex = widget.navigationShell.currentIndex;

    // set up listener for foreground messages
    ref.read(notificationsProvider.notifier).handleForeGroundMessages();

    Future.delayed(Duration.zero, () async {
      await NotificationController.scheduleDailyNotification();
    });
  }

  /// method used to navigate between different branches in th shell
  void _goBranch(int index) {
    widget.navigationShell.goBranch(
      index,
      initialLocation: index == widget.navigationShell.currentIndex,
    );
    setState(() {
      _currentPageIndex = index;
    });
  }

// enable users to swipe between tabs
  void _handleSwipe(DragEndDetails details) {
    if (details.primaryVelocity! > 0) {
      // Swiped right
      if (_currentPageIndex > 0) {
        widget.navigationShell.goBranch(_currentPageIndex - 1);
        setState(() {
          _currentPageIndex--;
        });
      }
    } else if (details.primaryVelocity! < 0) {
      // Swiped left
      if (_currentPageIndex < 5) {
        widget.navigationShell.goBranch(_currentPageIndex + 1);
        setState(() {
          _currentPageIndex++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onHorizontalDragEnd: _handleSwipe,
        child: widget.navigationShell,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentPageIndex,
        onDestinationSelected: _goBranch,
        destinations: [
          NavigationDestination(
            icon: SvgPicture.asset(
              'assets/images/home.svg',
              // width: 10,
              colorFilter: ColorFilter.mode(
                AppTabs.home.index == widget.navigationShell.currentIndex
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
                AppTabs.statistics.index == widget.navigationShell.currentIndex
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
                AppTabs.community.index == widget.navigationShell.currentIndex
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
                AppTabs.rewards.index == widget.navigationShell.currentIndex
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
                AppTabs.settings.index == widget.navigationShell.currentIndex
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
