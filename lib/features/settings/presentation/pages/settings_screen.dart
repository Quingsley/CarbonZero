import 'package:carbon_zero/core/extensions.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/widgets/profile_photo_card.dart';
import 'package:carbon_zero/features/auth/presentation/view_models/auth_view_model.dart';
import 'package:carbon_zero/features/settings/presentation/widgets/setting_tile.dart';
import 'package:carbon_zero/features/settings/presentation/widgets/update_names_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';

/// will have the user settings
class SettingsScreen extends ConsumerWidget {
  /// constructor call
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authVm = ref.watch(authViewModelProvider);
    final isLoading = authVm is AsyncLoading;
    final user = ref.watch(userStreamProvider);

    final isDarkMode = ref.read(isDarkModeStateProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(child: ProfilePhotoCard()),
            GestureDetector(
              onTap: () async {
                final user = ref.read(userStreamProvider);
                if (context.mounted) await updateUser(context, user.value, ref);
              },
              child: Chip(
                label: Text('${user.value?.fName} ${user.value?.lName}'),
                color: MaterialStatePropertyAll<Color>(
                  context.colors.primaryContainer,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  SettingsTile(
                    title: 'Notifications',
                    onTap: () => context.push('/notification'),
                    icon: const Icon(Icons.notifications),
                    iconColor: context.colors.primary,
                  ),
                  SettingsTile(
                    title: 'App Theme',
                    onTap: () {
                      ref.read(isDarkModeStateProvider.notifier).state =
                          !ref.read(isDarkModeStateProvider);
                    },
                    icon: Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode),
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
                    onTap: () => context.go('/community/admin'),
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
                    onTap: !isLoading
                        ? () async {
                            await ref
                                .read(authViewModelProvider.notifier)
                                .signOut();
                            if (context.mounted) context.go('/auth');
                          }
                        : () {},
                    icon: const Icon(Icons.logout_rounded),
                    iconColor: context.colors.error,
                    fillColor: context.colors.errorContainer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
