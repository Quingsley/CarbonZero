import 'dart:async';

import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// contain all the notification services
/// methods
class NotificationService extends AsyncNotifier<void> {
  /// request permission for notification
  Future<void> requestPermission() async {
    final firebaseMessaging = ref.read(firebaseMessagingProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final notificationSettings =
          await firebaseMessaging.requestPermission(provisional: true);
      final isGranted = notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized;
      if (isGranted) {
        final token = await firebaseMessaging.getToken();
        if (token != null) {
          ref.read(pushTokenProvider.notifier).state = token;
        }
      }
    });
  }

  @override
  FutureOr<void> build() {
    // TODO: implement build
    throw UnimplementedError();
  }
}

/// will provide the set of notification services
final notificationsProvider =
    AsyncNotifierProvider<NotificationService, void>(NotificationService.new);

/// will provide the push token
final pushTokenProvider = StateProvider<String?>((ref) {
  return null;
});
