import 'package:flutter/material.dart';

/// [AppThemeExtension] extension will get the current textTheme of the app
extension AppThemeExtension on BuildContext {
  /// gets  the current [TextTheme] form the given context
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// gets the app current [ColorScheme]
  ColorScheme get colors => Theme.of(this).colorScheme;
}
