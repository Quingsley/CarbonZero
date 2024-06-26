import 'dart:async';

import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:carbon_zero/core/utils/utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// contain all the notification services
/// methods
class NotificationService extends AsyncNotifier<void> {
  /// request permission for notification
  Future<void> requestPermission() async {
    final firebaseMessaging = ref.read(firebaseMessagingProvider);
    final preference = await ref.read(sharedPreferencesProvider.future);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final notificationSettings = await firebaseMessaging.requestPermission();
      final isGranted = notificationSettings.authorizationStatus ==
          AuthorizationStatus.authorized;
      if (isGranted) {
        final token = await firebaseMessaging.getToken();
        if (token != null) {
          ref.read(pushTokenProvider.notifier).state = token;

          // store the push token locally
          await preference.setString(fcmNtfKey, token);
        }
      }
    });
  }

  /// will handle foreground messages
  void handleForeGroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
      ref.read(notificationMessagesProvider.notifier).state.add(message);
      final storage = await ref.read(sharedPreferencesProvider.future);
      await storeNotifications(message, storage);
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

/// will have the list of messages
final notificationMessagesProvider = StateProvider<List<RemoteMessage>>((ref) {
  return [];
});
