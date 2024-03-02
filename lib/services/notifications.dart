import 'dart:async';

import 'package:carbon_zero/core/providers/shared_providers.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rxdart/rxdart.dart';

/// used to pass messages from event handler to the UI
final messageStreamController = BehaviorSubject<RemoteMessage>();

/// contain all the notification services
/// methods
class NotificationService extends AsyncNotifier<void> {
  /// request permission for notification
  Future<void> requestPermission() async {
    final firebaseMessaging = ref.read(firebaseMessagingProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final notificationSettings = await firebaseMessaging.requestPermission();
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

  /// will handle foreground messages
  void handleForeGroundMessages() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        print('Handling a foreground message: ${message.messageId}');
        print('Message data: ${message.data}');
        print('Message notification: ${message.notification?.title}');
        print('Message notification: ${message.notification?.body}');
      }
      messageStreamController.sink.add(message);
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
