import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/footer_reference.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// asks user about their personality
class PersonalityQ extends ConsumerWidget {
  /// asks user about their personality
  const PersonalityQ({required this.controller, super.key});

  /// page controller
  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final personality = ref.watch(personalityProvider);
    return Column(
      children: [
        Text(
          'We would like to know your personality?',
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 300,
          child: Material(
            borderRadius: BorderRadius.circular(10),
            elevation: 3,
            child: ListView(
              children: [
                ColoredBox(
                  color: personality == Personality.active
                      ? context.colors.primaryContainer
                      : context.colors.secondaryContainer,
                  child: ListTile(
                    onTap: () {
                      ref.read(personalityProvider.notifier).state =
                          Personality.active;
                    },
                    leading: const CircleAvatar(
                      child: Icon(Icons.directions_run),
                    ),
                    title: const Text('Active'),
                    subtitle: const Text(
                      'Involves regular physical activity, prioritizing exercise and movement, promoting physical fitness',
                    ),
                    trailing: Radio<Personality>(
                      value: Personality.active,
                      groupValue: personality,
                      onChanged: (val) {
                        ref.read(personalityProvider.notifier).state = val;
                      },
                    ),
                  ),
                ),
                const Divider(),
                ColoredBox(
                  color: personality == Personality.sedentary
                      ? context.colors.primaryContainer
                      : context.colors.secondaryContainer,
                  child: ListTile(
                    onTap: () {
                      ref.read(personalityProvider.notifier).state =
                          Personality.sedentary;
                    },
                    leading: const CircleAvatar(
                      child: Icon(Icons.weekend),
                    ),
                    title: const Text('Sedentary'),
                    subtitle: const Text(
                      'Characterized by low physical activity, spending much time sitting or lying down',
                    ),
                    trailing: Radio<Personality>(
                      value: Personality.sedentary,
                      groupValue: personality,
                      onChanged: (val) {
                        ref.read(personalityProvider.notifier).state = val;
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Spacer(),
        FooterReference(
          onTap: () {},
        ),
        PrimaryButton(
          text: 'Continue',
          onPressed: personality != null
              ? () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
              : null,
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
