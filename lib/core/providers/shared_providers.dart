import 'dart:convert';

import 'package:carbon_zero/core/constants/constants.dart';
import 'package:carbon_zero/services/notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// will provide an instance of [FirebaseFirestore]
final dbProvider = Provider<FirebaseFirestore?>((ref) {
  final authStateChanges = ref.watch(authStateChangesProvider);
  return authStateChanges.value?.uid != null
      ? FirebaseFirestore.instance
      : null;
});

/// will provide an instance of [FirebaseAuth]
final authInstanceProvider =
    Provider<FirebaseAuth>((ref) => FirebaseAuth.instance);

/// will provide an instance of [FirebaseStorage]
final storageProvider =
    Provider<FirebaseStorage>((ref) => FirebaseStorage.instance);

/// will listen to auth state changes
final authStateChangesProvider = StreamProvider<User?>(
  (ref) {
    final auth = ref.watch(authInstanceProvider);
    return auth.authStateChanges();
  },
);

/// toggles the theme of the app
final isDarkModeStateProvider = StateProvider<bool>((ref) => false);

/// checks if the user has onboard
final didUserOnBoardProvider = StateProvider<bool>((ref) {
  return false;
});

/// shared preferences provider
final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return SharedPreferences.getInstance();
});

/// app startup provider
final appStartupProvider = FutureProvider<void>((ref) async {
  ref.onDispose(() {
    // ensure we invalidate all the providers we depend on
    ref.invalidate(sharedPreferencesProvider);
  });
  // all asynchronous app initialization code should belong here:
  final preference = await ref.watch(sharedPreferencesProvider.future);
  final storedValue = preference.getString('didUserOnboard');
  if (storedValue == null) {
    await preference.setString('didUserOnboard', 'didUserOnboard');
  } else {
    final themeState = preference.getBool('themeState');
    if (themeState != null && themeState) {
      ref.read(isDarkModeStateProvider.notifier).state = !themeState;
    }
    ref.read(didUserOnBoardProvider.notifier).state = true;
    final ntfDataStored = preference.get(notificationKey);
    if (ntfDataStored != null) {
      final pendingNotifications =
          jsonDecode(ntfDataStored.toString()) as Map<String, dynamic>;
      for (final message in pendingNotifications.values) {
        messageStreamController.sink
            .add(RemoteMessage.fromMap(message as Map<String, dynamic>));
      }
    }
  }
});

/// will provide an instance of [FirebaseMessaging]
final firebaseMessagingProvider = Provider<FirebaseMessaging>((ref) {
  return FirebaseMessaging.instance;
});

/// will highlight the text or imageContainer
final showErrorProvider = StateProvider<bool>((ref) {
  return false;
});
