import 'package:flutter/material.dart';

class ThemeColors {
  // Primary and accent colors
  static const Color primaryColor = Color(0xFF1976D2); // Vibrant Blue
  static const Color successColor = Color(0xFF43D676); // Green for progress
  static const Color highlightColor = Color(
    0xFFFF9100,
  ); // Orange for highlights

  // Card backgrounds
  static Color getCardColor(bool isDark) =>
      isDark ? const Color(0xFF23272F) : const Color(0xFFFFFFFF);

  // Accent backgrounds
  static Color getAccentColor(bool isDark) =>
      isDark ? const Color(0xFF181A20) : const Color(0xFFF7F7F7);

  // Text colors
  static Color getTextColor(bool isDark) =>
      isDark ? const Color(0xFFFFFFFF) : const Color(0xFF23272F);
  static Color getMutedTextColor(bool isDark) =>
      isDark ? const Color(0xFFB0B0B0) : const Color(0xFF757575);

  // Progress bar color
  static Color getProgressColor(bool isDark) =>
      isDark ? successColor : successColor;

  // Highlight color for buttons or actions
  static Color getHighlightColor(bool isDark) => highlightColor;

  // Error/alert color
  static const Color errorColor = Color(0xFFFF5252);
}
