import 'package:flutter/material.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart';

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
    // If the URL launch fails, an exception will be thrown. (For example, if no browser app is installed on the Android device.)
    debugPrint(e.toString());
  }
}
