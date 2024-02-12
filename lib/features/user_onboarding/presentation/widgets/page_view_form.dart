import 'package:carbon_zero/features/user_onboarding/presentation/widgets/question_1.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/question_2.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/question_3.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/question_4.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/widgets/question_5.dart';
import 'package:flutter/material.dart';

/// will have a the list of questions on a page view
class PageViewForm extends StatefulWidget {
  /// will have a the list of questions on a page view
  const PageViewForm({required this.controller, super.key});

  /// controller
  final PageController controller;

  @override
  State<PageViewForm> createState() => _PageViewFormState();
}

class _PageViewFormState extends State<PageViewForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: PageView(
        onPageChanged: print,
        physics: const NeverScrollableScrollPhysics(),
        controller: widget.controller,
        children: [
          CountryQ(
            controller: widget.controller,
          ),
          PersonalityQ(
            controller: widget.controller,
          ),
          DietaryQ(
            controller: widget.controller,
          ),
          ModeOfTransportQ(
            controller: widget.controller,
          ),
          EnergyConsumptionQ(
            controller: widget.controller,
          ),
        ],
      ),
    );
  }
}
