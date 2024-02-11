import 'dart:convert';

import 'package:carbon_zero/features/auth/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// This class is used to store data locally on the device
class LocalStorage {
  /// factory constructor that returns the singleton instance
  factory LocalStorage() {
    return _localStorage;
  }

  /// private constructor
  LocalStorage._internal();

  /// checks if the user has completed the onboarding process
  static bool didUserOnboard = false;

  /// key for the [didUserOnboard] variable
  final String _didUserOnboardKey = 'didUserOnboard';

  // needs to be a singleton pattern
  static final LocalStorage _localStorage = LocalStorage._internal();

  /// initializes the app
  Future<void> init() async {
    final preference = await SharedPreferences.getInstance();
    final storedValue = preference.getString(_didUserOnboardKey);
    if (storedValue == null) {
      await preference.setString(_didUserOnboardKey, _didUserOnboardKey);
    }
  }

  /// reads the value of the [didUserOnboard] variable
  Future<void> readOnboarding() async {
    final preference = await SharedPreferences.getInstance();
    final value = preference.getString(_didUserOnboardKey);
    if (value != null) didUserOnboard = true;
  }

  /// stores user data in local storage
  Future<void> setUser(UserModel user) async {
    final preference = await SharedPreferences.getInstance();
    await preference.setString('user', jsonEncode(user.toJson()));
  }

  /// reads user from local device
  Future<UserModel?> getUser() async {
    final preference = await SharedPreferences.getInstance();
    final data = preference.getString('user');
    if (data != null) {
      final json = jsonDecode(data) as Map<String, dynamic>;
      return UserModel.fromJson(json);
    }
    return null;
  }

  /// removes user data on sign out
  Future<void> removeUserData() async {
    final preference = await SharedPreferences.getInstance();
    await preference.remove('user');
  }
}
