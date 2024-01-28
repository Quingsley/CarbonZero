import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/features/settings/presentation/widgets/setting_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// will have the user settings
class SettingsScreen extends StatelessWidget {
  /// constructor call
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            SettingsTile(
              title: 'Profile',
              onTap: () => context.push('/profile'),
              icon: const Icon(Icons.person),
              iconColor: context.colors.primary,
            ),
            SettingsTile(
              title: 'Notifications',
              onTap: () => context.push('/notification'),
              icon: const Icon(Icons.notifications),
              iconColor: context.colors.primary,
            ),
            SettingsTile(
              title: 'App Theme',
              onTap: () {},
              icon: const Icon(Icons.dark_mode),
              iconColor: context.colors.primary,
            ),
            SettingsTile(
              title: 'Privacy',
              onTap: () {},
              icon: const Icon(Icons.privacy_tip),
              iconColor: context.colors.primary,
            ),
            const Divider(
              thickness: 2,
            ),
            SettingsTile(
              title: 'Community',
              onTap: () {},
              icon: SvgPicture.asset(
                'assets/images/community-icon.svg',
                width: 24,
                colorFilter: ColorFilter.mode(
                  context.colors.primary,
                  BlendMode.srcIn,
                ),
              ),
              iconColor: context.colors.primary,
            ),
            SettingsTile(
              title: 'FAQs',
              onTap: () {},
              icon: const Icon(Icons.message),
              iconColor: context.colors.primary,
            ),
            SettingsTile(
              title: 'Log out',
              onTap: () {},
              icon: const Icon(Icons.logout_rounded),
              iconColor: context.colors.error,
              fillColor: context.colors.errorContainer,
            ),
          ],
        ),
      ),
    );
  }
}
