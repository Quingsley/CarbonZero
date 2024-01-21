// Theme config for FlexColorScheme version 7.3.x. Make sure you use
// same or higher package version, but still same major version. If you
// use a lower package version, some properties may not be supported.
// In that case remove them after copying this theme to your app.
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

///dark theme generated from flex color scheme playground
final lightTheme = FlexThemeData.light(
  colors: const FlexSchemeColor(
    primary: Color(0xff27ae60),
    primaryContainer: Color(0xff93d7af),
    secondary: Color(0xffeef9f2),
    secondaryContainer: Color(0xffffdbcf),
    tertiary: Color(0xffd9d9d9),
    tertiaryContainer: Color(0xff95f0ff),
    appBarColor: Color(0xffffdbcf),
    error: Color(0xffb00020),
  ),
  usedColors: 5,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 7,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 10,
    blendOnColors: false,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    inputDecoratorBorderType: FlexInputBorderType.underline,
    inputDecoratorUnfocusedBorderIsColored: false,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
  ),
  tones: FlexTones.jolly(Brightness.light),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  fontFamily: GoogleFonts.quicksand().fontFamily,
);

/// dark theme generated from flex color scheme playground
final darkTheme = FlexThemeData.dark(
  colors: const FlexSchemeColor(
    primary: Color(0xff27ae60),
    primaryContainer: Color(0xff93d7af),
    secondary: Color(0xffeef9f2),
    secondaryContainer: Color(0xff872100),
    tertiary: Color(0xffd9d9d9),
    tertiaryContainer: Color(0xff004e59),
    appBarColor: Color(0xff872100),
    error: Color(0xffcf6679),
  ),
  usedColors: 5,
  surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
  blendLevel: 13,
  subThemesData: const FlexSubThemesData(
    blendOnLevel: 20,
    useTextTheme: true,
    useM2StyleDividerInM3: true,
    inputDecoratorBorderType: FlexInputBorderType.underline,
    inputDecoratorUnfocusedBorderIsColored: false,
    alignedDropdown: true,
    useInputDecoratorThemeInDialogs: true,
  ),
  keyColors: const FlexKeyColors(
    useSecondary: true,
    useTertiary: true,
    keepPrimary: true,
    keepSecondary: true,
    keepTertiary: true,
  ),
  tones: FlexTones.jolly(Brightness.dark),
  visualDensity: FlexColorScheme.comfortablePlatformDensity,
  useMaterial3: true,
  swapLegacyOnMaterial3: true,
  // To use the Playground font, add GoogleFonts package and uncomment
  fontFamily: GoogleFonts.quicksand().fontFamily,
);
