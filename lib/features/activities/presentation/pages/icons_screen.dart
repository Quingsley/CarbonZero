import 'package:carbon_zero/core/constants/icon_pack.dart';
import 'package:carbon_zero/core/widgets/form_layout.dart';
import 'package:carbon_zero/features/activities/presentation/widgets/icon_pack_grid.dart';
import 'package:flutter/material.dart';

/// allows user to pick an icon for a goal being created
class IconSelectionScreen extends StatelessWidget {
  /// allows user to pick an icon for a goal being created
  const IconSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Icon'),
      ),
      body: FormLayout(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Home'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: homeIcons,
              ),
            ),
            const Text('Sports'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: sportsIcons,
              ),
            ),
            const Text('Food'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: foodIcons,
              ),
            ),
            const Text('Beverages'),
            SizedBox(
              height: 50,
              child: IconPack(
                icons: beverageIcons,
              ),
            ),
            const Text('Transport'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: transportIcons,
              ),
            ),
            const Text('Community and Activism'),
            SizedBox(
              height: 50,
              child: IconPack(
                icons: communityIcons,
              ),
            ),
            const Text('Nature and Environment'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: natureIcons,
              ),
            ),
            const Text('Energy and Technology'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: energyIcons,
              ),
            ),
            const Text('Health and wellness'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: healthIcons,
              ),
            ),
            const Text('Financial'),
            SizedBox(
              height: 90,
              child: IconPack(
                icons: financialIcons,
              ),
            ),
            const Text('Miscellaneous'),
            SizedBox(
              height: 130,
              child: IconPack(
                icons: miscellaneousIcons,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
