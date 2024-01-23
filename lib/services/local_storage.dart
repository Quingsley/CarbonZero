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
  final String didUserOnboardKey = 'didUserOnboard';

  // needs to be a singleton pattern
  static final LocalStorage _localStorage = LocalStorage._internal();

  /// initializes the app
  Future<void> init() async {
    final preference = await SharedPreferences.getInstance();
    final storedValue = preference.getString(didUserOnboardKey);

    if (storedValue == null) {
      await preference.setString(didUserOnboardKey, didUserOnboardKey);
    }
  }

  /// reads the value of the [didUserOnboard] variable
  Future<void> readOnboarding() async {
    final preference = await SharedPreferences.getInstance();
    final value = preference.getString('didUserOnboard');
    if (value != null) didUserOnboard = true;
  }
}
