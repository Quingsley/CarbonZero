import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/onboarding/presentation/widgets/on_boarding_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Notifies the user that [ProfileSetupComplete]
class ProfileSetupComplete extends StatelessWidget {
  ///constructor call
  const ProfileSetupComplete({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const OnBoardingCard(
            title: "You're all set up !",
            description: 'Time to join the fight against climate change',
            image: 'assets/images/storage_work.svg',
          ),
          const Spacer(),
          PrimaryButton(text: 'Continue', onPressed: () => context.go('/home')),
          const SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
