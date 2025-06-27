import 'package:flutter/material.dart';

class ThemeColors {
  static const Color primaryColor = Color(0xFF2979FF); // Electric Blue
  static const Color accentColorDark = Color(0xFF23272A); // Charcoal
  static const Color accentColorLight = Color(0xFFE3F2FD); // Light blue
  static const Color cardColorDark = Color(
    0xFF2C2F33,
  ); // Slightly lighter for cards
  static const Color cardColorLight = Color(
    0xFFF5F7FA,
  ); // Slightly lighter for cards

  static Color getAccentColor(bool isDark) {
    return isDark ? accentColorDark : accentColorLight;
  }

  static Color getCardColor(bool isDark) {
    return isDark ? cardColorDark : cardColorLight;
  }

  static Color getTextColor(bool isDark) {
    return isDark ? Colors.white : Colors.black;
  }
}
