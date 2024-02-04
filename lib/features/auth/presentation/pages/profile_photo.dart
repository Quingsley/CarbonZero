import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/core/widgets/profile_photo_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// [ProfilePhotoScreen] screen that allows user to set profile photo
class ProfilePhotoScreen extends StatelessWidget {
  ///constructor call
  const ProfilePhotoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add a photo',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              'Make it easy to recognize you',
              style: Theme.of(context).textTheme.labelLarge,
              textAlign: TextAlign.left,
            ),
            const SizedBox(
              height: 50,
            ),
            const ProfilePhotoCard(),
            const Spacer(),
            PrimaryButton(
              text: 'Continue',
              onPressed: () {
                context.go('/auth/profile-complete');
              },
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
