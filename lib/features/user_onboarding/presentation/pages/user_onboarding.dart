import 'package:carbon_zero/features/user_onboarding/presentation/widgets/k_timeline_tile.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/page_view_form.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [UserOnboarding] will be used to collect info about the
/// user to know more about the user in order to get the initial
/// carbon footprint will involve a stepper
class UserOnboarding extends ConsumerStatefulWidget {
  /// [UserOnboarding] will be used to collect info about the
  /// user to know more about the user in order to get the initial
  /// carbon footprint will involve a stepper
  const UserOnboarding({super.key});

  @override
  ConsumerState<UserOnboarding> createState() => _UserOnboardingState();
}

class _UserOnboardingState extends ConsumerState<UserOnboarding> {
  PageController controller = PageController();
  @override
  void initState() {
    super.initState();
    controller.addListener(listener);
  }

  void listener() {
    ref.read(currentPageProvider.notifier).state = controller.page!.toInt();
  }

  @override
  void dispose() {
    super.dispose();
    controller
      ..dispose()
      ..removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    final currentPage = ref.watch(currentPageProvider);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 50, left: 8, right: 8),
        child: Stack(
          children: [
            PageViewForm(
              controller: controller,
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (controller.hasClients && currentPage != 0)
                  Material(
                    borderRadius: BorderRadius.circular(50),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(50),
                        splashFactory: NoSplash.splashFactory,
                        onTap: () {
                          controller.previousPage(
                            duration: const Duration(milliseconds: 500),
                            curve: Curves.easeInOut,
                          );
                        },
                        child: const Icon(
                          Icons.arrow_back_ios_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                KTimelineTile(
                  isFirst: true,
                  isLast: false,
                  isPast: currentPage > 0,
                ),
                KTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: currentPage > 1,
                ),
                KTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: currentPage > 2,
                ),
                KTimelineTile(
                  isFirst: false,
                  isLast: false,
                  isPast: currentPage > 3,
                ),
                KTimelineTile(
                  isFirst: false,
                  isPast: currentPage > 4,
                  isLast: false,
                ),
                KTimelineTile(
                  isLast: true,
                  isFirst: false,
                  isPast: currentPage == 5,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
