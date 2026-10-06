import 'package:flutter/material.dart';

class ThemeController {
  static final ValueNotifier<bool> isDarkMode = ValueNotifier<bool>(false);

  static void setDarkMode(bool isDark) {
    isDarkMode.value = isDark;
  }

  static void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
  }
}
