import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/box_image.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Recycling question
class RecyclingQ extends ConsumerWidget {
  /// Recycling question
  const RecyclingQ({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isRecyclingNewspaper = ref.watch(newsPaperProvider);
    final isRecyclingAluminum = ref.watch(aluminumProvider);
    return Column(
      children: [
        Text(
          "Let's talk about recycling.",
          style: context.textTheme.titleLarge,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        Expanded(
          child: ListView(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: isRecyclingNewspaper
                    ? context.colors.primaryContainer
                    : context.colors.secondaryContainer,
                child: ListTile(
                  onTap: () {
                    ref.read(newsPaperProvider.notifier).state =
                        !isRecyclingNewspaper;
                  },
                  leading: const BoxImage(path: 'assets/images/newspaper.png'),
                  title: const Text('Do you recycle newspapers at home'),
                  subtitle:
                      const Text('Select if you recycle newspapers at home'),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                color: isRecyclingAluminum
                    ? context.colors.primaryContainer
                    : context.colors.secondaryContainer,
                child: ListTile(
                  onTap: () {
                    ref.read(aluminumProvider.notifier).state =
                        !isRecyclingAluminum;
                  },
                  leading: const BoxImage(path: 'assets/images/aluminum.png'),
                  title:
                      const Text('Do you recycle Aluminum or tin cans at home'),
                  subtitle: const Text('Select if you recycle '),
                ),
              ),
            ],
          ),
        ),
        const Spacer(),
        PrimaryButton(
          text: 'Finish',
          onPressed: isRecyclingAluminum || isRecyclingNewspaper
              ? () {
                  context.go('/carbon-footprint-results');
                }
              : null,
        ),
        const SizedBox(height: 20),
      ],
    );
  }
}
