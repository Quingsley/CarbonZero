import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
