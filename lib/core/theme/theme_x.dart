import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Theme aware colour helpers built on top of `Theme.of(context)`.
///
/// Screens keep using the Rx Events palette, but the values adapt to the
/// brightness selected in Settings / Profile so every screen stays readable
/// in dark mode.
extension AppThemeX on BuildContext {
  ThemeData get _theme => Theme.of(this);

  bool get isDarkMode => _theme.brightness == Brightness.dark;

  /// Scaffold background.
  Color get bg => _theme.scaffoldBackgroundColor;

  /// Main card / sheet surface.
  Color get card => isDarkMode ? const Color(0xFF1E293B) : Colors.white;

  /// Slightly inset surface (icon tiles, image placeholders, chips).
  Color get cardAlt =>
      isDarkMode ? const Color(0xFF0B1220) : AppColors.background;

  /// Surface for the "mint" areas of the light theme.
  Color get tintSurface =>
      isDarkMode ? AppColors.primary.withValues(alpha: 0.22) : AppColors.light;

  /// AppBar surface for screens that used the mint app bar.
  Color get appBarSurface =>
      isDarkMode ? const Color(0xFF115E59) : AppColors.light;

  /// Primary text colour.
  Color get textPrimary =>
      isDarkMode ? const Color(0xFFE5E7EB) : AppColors.text;

  /// Secondary text colour.
  Color get textMuted =>
      isDarkMode ? Colors.grey.shade400 : Colors.grey.shade700;

  /// Tertiary / faint text colour.
  Color get textFaint =>
      isDarkMode ? Colors.grey.shade500 : Colors.grey.shade600;

  /// Divider and card border colour.
  Color get outline => isDarkMode ? Colors.grey.shade700 : Colors.grey.shade200;

  /// Stronger border colour.
  Color get outlineStrong =>
      isDarkMode ? Colors.grey.shade600 : Colors.grey.shade300;

  /// Brand teal used for text and icons.
  Color get accent => isDarkMode ? const Color(0xFF2DD4BF) : AppColors.primary;

  /// Brand teal used when it sits on a tinted surface.
  Color get accentStrong =>
      isDarkMode ? const Color(0xFF14B8A6) : AppColors.dark;

  /// Warning text colour.
  Color get warningText =>
      isDarkMode ? Colors.orange.shade300 : Colors.orange.shade800;

  /// Warning pill / badge surface.
  Color get warningSurface => isDarkMode
      ? Colors.orange.withValues(alpha: 0.18)
      : Colors.orange.shade50;

  /// Danger text colour.
  Color get dangerText =>
      isDarkMode ? Colors.red.shade300 : Colors.red.shade700;

  /// Danger pill / badge surface.
  Color get dangerSurface =>
      isDarkMode ? Colors.red.withValues(alpha: 0.18) : Colors.red.shade50;
}
