import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFFfe0000),
  secondaryHeaderColor: const Color(0xFF1ED7AA),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(style: TextButton.styleFrom(foregroundColor: Colors.deepOrange)),
  colorScheme: const ColorScheme.light(primary: Colors.deepOrange,
      secondary:Colors.deepOrange).copyWith(
      background: const Color(0xFFF3F3F3)).copyWith(
      error: const Color(0xFFE84D4F)),
);