import 'dart:convert';

import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:carbon_zero/features/auth/data/repositories/auth_repo_impl.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Returns a hash code for a [DateTime] object.
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/// used to open a custom chrome tab with the given url
Future<void> openCustomTab(BuildContext context, String url) async {
  final theme = Theme.of(context);
  try {
    await launchUrl(
      Uri.parse(url),
      customTabsOptions: CustomTabsOptions(
        colorSchemes: CustomTabsColorSchemes.defaults(
          toolbarColor: theme.colorScheme.surface,
        ),
        shareState: CustomTabsShareState.on,
        urlBarHidingEnabled: true,
        showTitle: true,
        closeButton: CustomTabsCloseButton(
          icon: CustomTabsCloseButtonIcons.back,
        ),
      ),
      safariVCOptions: SafariViewControllerOptions(
        preferredBarTintColor: theme.colorScheme.surface,
        preferredControlTintColor: theme.colorScheme.onSurface,
        barCollapsingEnabled: true,
        dismissButtonStyle: SafariViewControllerDismissButtonStyle.close,
      ),
    );
  } catch (e) {
    // If the URL launch fails, an exception will be thrown.
    //(For example, if no browser app is installed on the Android device.)
    debugPrint(e.toString());
  }
}

/// will preload svg and cache them before the app starts
Future<void> preloadSVG(List<String> assetPaths) async {
  for (final path in assetPaths) {
    final loader = SvgAssetLoader(path);
    await svg.cache.putIfAbsent(
      loader.cacheKey(null),
      () => loader.loadBytes(null),
    );
  }
}

/// will store notification data in shared preferences
Future<void> storeNotifications(
  RemoteMessage message,
  SharedPreferences storage,
) async {
  final dataStored = storage.get(notificationKey);
  if (dataStored != null) {
    final pendingNotifications =
        jsonDecode(dataStored.toString()) as Map<String, dynamic>;
    pendingNotifications[message.messageId!] = message.toMap();
    await storage.setString(notificationKey, jsonEncode(pendingNotifications));
  } else {
    final initialList = {message.messageId!: message.toMap()};
    await storage.setString(notificationKey, jsonEncode(initialList));
  }
}

/// will check the current push token and update it if null or update if it
///  is not in the user tokens
Future<void> checkPushToken(WidgetRef ref, UserModel user) async {
  final preference = await ref.read(sharedPreferencesProvider.future);
  final pushToken = preference.getString(fcmNtfKey);
  debugPrint(('local push token--------', pushToken).toString());

  if (pushToken == null) {
    // request for a new push token
    await ref.read(notificationsProvider.notifier).requestPermission();
    final newPushToken = ref.read(pushTokenProvider);
    debugPrint(('new push token-----------', newPushToken).toString());
    if (pushToken != null) {
      debugPrint('-------updating token-----------');
      await ref
          .read(authRepositoryProvider)
          .updatePushToken(newPushToken!, user.userId!);
    }
  } else {
    final token = ref.read(pushTokenProvider);
    final isPresent = user.pushTokens.contains(token);
    if (!isPresent && token != null) {
      await ref
          .read(authRepositoryProvider)
          .updatePushToken(token, user.userId!);
    }
  }
}
