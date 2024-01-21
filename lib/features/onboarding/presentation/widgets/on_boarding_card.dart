import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

///[OnBoardingCard] widget.
class OnBoardingCard extends StatelessWidget {
  /// Create const instance of [OnBoardingCard] widget.
  const OnBoardingCard({
    required this.title,
    required this.description,
    required this.image,
    super.key,
  });

  /// Title of the onboarding screen.
  final String title;

  /// Description of the onboarding screen.
  final String description;

  /// Image of the onboarding screen.
  final String image;
  @override
  Widget build(BuildContext context) {
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset(
          image,
          width: MediaQuery.sizeOf(context).width * .8,
        ),
        SizedBox(
          height: MediaQuery.sizeOf(context).height * .1,
        ),
        Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ],
    );
  }
}
