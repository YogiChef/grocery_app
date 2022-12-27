import 'package:flutter/material.dart';

class Styles {
  static ThemeData themeData(bool isDarkTheme, BuildContext context) {
    return ThemeData(
        scaffoldBackgroundColor:
            isDarkTheme ? Colors.black : Colors.grey.shade100,
        primaryColor: Colors.teal,
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: isDarkTheme ? Colors.black : Colors.grey.shade100,
              brightness: isDarkTheme ? Brightness.dark : Brightness.light,
            ),
        cardColor: isDarkTheme ? Colors.yellow.shade700 : Colors.white,
        canvasColor: isDarkTheme ? Colors.black : Colors.grey.shade100,
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
            colorScheme: isDarkTheme
                ? const ColorScheme.dark()
                : const ColorScheme.dark()));
  }
}
