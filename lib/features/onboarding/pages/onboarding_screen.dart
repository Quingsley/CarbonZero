import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/onboarding/widgets/on_boarding_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// simple [OnBoardingScreen] widget using [PageView].
class OnBoardingScreen extends StatefulWidget {
  /// Create const instance of [OnBoardingScreen] widget.
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late final PageController pageController;
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    pageController = PageController();
    currentPage = pageController.initialPage;
    pageController.addListener(listener);
  }

  void listener() {
    setState(() {
      currentPage = pageController.page!.toInt();
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController
      ..dispose()
      ..removeListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        clipBehavior: Clip.none,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100),
            child: PageView(
              controller: pageController,
              children: const [
                OnBoardingCard(
                  title: 'Carbon tracking made simple',
                  description:
                      'Discover eco friendly alternatives\nand make sustainable choices with\n ease',
                  image: 'assets/images/ecology _light.svg',
                ),
                OnBoardingCard(
                  title: 'Be a climate hero',
                  description:
                      'Easily track your carbon footprint\nand make positive change for the planet',
                  image: 'assets/images/hobby _activity.svg',
                ),
                OnBoardingCard(
                  title: 'Go green with ease',
                  description:
                      'Reduce your carbon footprint, one step at a time',
                  image: 'assets/images/nature _gardening.svg',
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 150,
            left: 150,
            child: Row(
              children: List.generate(
                3,
                (index) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: currentPage == index
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.tertiary,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: currentPage == index ? 25 : 15,
                  width: 5,
                ),
              ),
            ),
          ),
          if (currentPage < 2)
            Positioned(
              bottom: 10,
              child: Row(
                children: [
                  TextButton(
                    onPressed: () => context.go('/auth'),
                    child: Text(
                      'Skip',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.sizeOf(context).width * .6,
                  ),
                  Material(
                    elevation: 4,
                    color: Theme.of(context).colorScheme.primary,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: InkWell(
                      onTap: () {
                        pageController.nextPage(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeInCubic,
                        );
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Icon(
                          Icons.arrow_right_alt,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
      floatingActionButton: currentPage == 2
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: PrimaryButton(
                text: 'Get Started',
                onPressed: () => context.go('/auth'),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
