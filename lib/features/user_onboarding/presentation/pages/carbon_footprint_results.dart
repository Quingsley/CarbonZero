import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/widgets/primary_button.dart';
import 'package:carbon_zero/features/auth/presentation/widgets/google_button.dart';
import 'package:carbon_zero/features/home/presentation/widgets/carbon_foot_print.dart';
import 'package:carbon_zero/features/user_onboarding/presentation/view_models/carbon_foot_print_results_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// [CarbonFootPrintResults] widget shows the results of the carbon footprint
/// of the user after the user has completed the onboarding process
/// will also have recommendations on daily  tips/ topics on how to reduce the
/// carbon footprint of the user and goals the user can
/// take to reduce the carbon footprint
class CarbonFootPrintResults extends ConsumerStatefulWidget {
  /// [CarbonFootPrintResults] widget shows the results of the carbon footprint
  const CarbonFootPrintResults({super.key});

  @override
  ConsumerState<CarbonFootPrintResults> createState() =>
      _CarbonFootPrintResultsState();
}

class _CarbonFootPrintResultsState
    extends ConsumerState<CarbonFootPrintResults> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () async {
      await ref
          .read(carbonFootPrintViewModelProvider.notifier)
          .getCarbonFootPrint();
    });
  }

  @override
  Widget build(BuildContext context) {
    final carbonVm = ref.watch(carbonFootPrintViewModelProvider);
    final footPrint = carbonVm.value;
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: true,
            backgroundColor: context.colors.primary,
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Padding(
                padding: const EdgeInsets.only(top: 30),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: RadialGradient(
                      tileMode: TileMode.repeated,
                      center: AlignmentDirectional.bottomCenter,
                      stops: const [0.5, 1.0],
                      colors: [
                        context.colors.primary,
                        context.colors.surface,
                      ],
                    ),
                  ),
                  child: CarbonFootPrintData(
                    value: footPrint ?? 0,
                    per: 'year',
                  ),
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                const SizedBox(
                  height: 30,
                ),
                Text(
                  '🚀 Your carbon footprint is ${footPrint?.toStringAsFixed(2) ?? 0} kg CO2e per year',
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  word(footPrint ?? 0),
                  textAlign: TextAlign.center,
                  style: context.textTheme.titleMedium,
                ),
                // Recommendations
                const SizedBox(height: 20),
                Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Card(
                      elevation: 5,
                      shadowColor: context.colors.onSurface.withOpacity(.2),
                      margin: const EdgeInsets.symmetric(horizontal: 12),
                      child: const Column(
                        children: [
                          SizedBox(height: 20),
                          ListTile(
                            leading: Icon(
                              Icons.lightbulb_outline_rounded,
                              color: Colors.green,
                            ),
                            title: Text(
                              '💡 Daily Tips',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Get daily tips to help you reduce your carbon footprint and live more sustainably.',
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.star_outline_rounded,
                              color: Colors.blue,
                            ),
                            title: Text(
                              '🎯 Goals',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Set achievable goals to track your progress and make a positive impact on the environment.',
                            ),
                          ),
                          ListTile(
                            leading: Icon(
                              Icons.people_outline_rounded,
                              color: Colors.orange,
                            ),
                            title: Text(
                              '🌍 Community',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              'Join our vibrant community challenges to collaborate with others and amplify your efforts in reducing your carbon footprint.',
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: MediaQuery.sizeOf(context).width / 2.2,
                      top: -10,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: context.colors.primary,
                        child: const Icon(
                          Icons.verified_user_rounded,
                          color: Colors.amberAccent,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'To keep track of your carbon footprint, you will need an account.',
                    textAlign: TextAlign.center,
                    style: context.textTheme.titleMedium,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(4),
                  child: PrimaryButton(
                    text: 'Continue with Email',
                    onPressed: () => context.go('/auth/sign-up'),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(4),
                  child: GButton(
                    text: 'Continue with Google',
                    isLogin: false,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// [word] returns a string based on the value of the carbon footprint
String word(double value) {
  if (value < 2700) {
    return 'This is lower than the global average carbon footprint  which is 7000 kg CO2e per year';
  } else if (value >= 2700 && value <= 7250) {
    return 'This is an ideal carbon footprint and continues to be lower than the global average of 7250 kg CO2e per year';
  } else if (value >= 7250 && value <= 10000) {
    return 'This is an average carbon footprint and continues to be higher than the global average of 7250 kg CO2e per year';
  } else {
    return 'You may want to take some of the living green initiatives to reduce your carbon footprint.';
  }
}
