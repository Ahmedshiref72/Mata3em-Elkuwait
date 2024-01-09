import 'package:efood_multivendor/util/app_constants.dart';
import 'package:flutter/material.dart';

ThemeData light = ThemeData(
  fontFamily: AppConstants.fontFamily,
  primaryColor: const Color(0xFFfbc304),
  secondaryHeaderColor: const Color(0xFF1ED7AA),
  disabledColor: const Color(0xFFBABFC4),
  brightness: Brightness.light,
  hintColor: const Color(0xFF9F9F9F),
  cardColor: Colors.white,
  textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: Color(0xFFfbc304))),
  colorScheme: ColorScheme.light(
          primary: Color(0xFFfbc304), secondary: Color(0xFFfbc304))
      .copyWith(background: const Color(0xFFF3F3F3))
      .copyWith(error: const Color(0xFFE84D4F)),
);
