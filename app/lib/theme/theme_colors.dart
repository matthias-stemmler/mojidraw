import 'package:flutter/material.dart';

class ThemeColors {
  ThemeColors._();

  static const MaterialColor mojidraw =
      MaterialColor(_mojidrawPrimaryValue, <int, Color>{
    50: Color(0xFFE8F0F7),
    100: Color(0xFFC6D9EC),
    200: Color(0xFFA0C0E0),
    300: Color(0xFF79A6D3),
    400: Color(0xFF5D93C9),
    500: Color(_mojidrawPrimaryValue),
    600: Color(0xFF3A78BA),
    700: Color(0xFF326DB2),
    800: Color(0xFF2A63AA),
    900: Color(0xFF1C509C),
  });

  static const int _mojidrawPrimaryValue = 0xFF4080C0;
}
