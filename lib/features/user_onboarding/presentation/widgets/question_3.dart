import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/footer_reference.dart';
import 'package:carbon_zero/features/user_onboarding/providers/user_onboarding_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// [DietaryQ] widget
/// will simply ask user the type of diet they follow
class DietaryQ extends ConsumerWidget {
  /// [DietaryQ] widget
  /// will simply ask user the type of diet they follow
  const DietaryQ({required this.controller, super.key});

  /// controller
  final PageController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dietType = ref.watch(dietTypeProvider);
    return Column(
      children: [
        Text(
          'What type of diet do you follow?',
          style: context.textTheme.titleLarge,
        ),
        const SizedBox(
          height: 50,
        ),
        SizedBox(
          height: 350,
          child: Material(
            elevation: 3,
            borderRadius: BorderRadius.circular(10),
            child: ListView(
              children: DietType.values
                  .map(
                    (type) => Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: ColoredBox(
                        color: type == dietType
                            ? context.colors.primaryContainer
                            : context.colors.secondaryContainer,
                        child: ListTile(
                          onTap: () {
                            ref.read(dietTypeProvider.notifier).state = type;
                          },
                          leading: CircleAvatar(
                            backgroundImage: AssetImage(
                              imageUrl(type),
                            ),
                          ),
                          title: Text(type.label),
                          trailing: Radio<DietType>(
                            value: type,
                            groupValue: dietType,
                            onChanged: (val) {
                              ref.read(dietTypeProvider.notifier).state = val;
                            },
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ),
        const Spacer(),
        FooterReference(onTap: () {}),
        PrimaryButton(
          text: 'Continue',
          onPressed: dietType != null
              ? () {
                  controller.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.easeIn,
                  );
                }
              : null,
        ),
        const SizedBox(
          height: 50,
        ),
      ],
    );
  }
}
