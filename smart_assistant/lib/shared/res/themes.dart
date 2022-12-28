import 'package:flutter/material.dart';
import 'res.dart';

class SmartAssistantTheme {
  static final ThemeData lightTheme = ThemeData(
      primaryColor: SmartAssistantColors.primary,
      scaffoldBackgroundColor: SmartAssistantColors.white,
      splashColor: Colors.transparent,
      brightness: Brightness.light,
      highlightColor: Colors.transparent,
      dividerColor: Colors.transparent,
      fontFamily: 'Verdana',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        showUnselectedLabels: true,
        backgroundColor: SmartAssistantColors.white,
        selectedItemColor: SmartAssistantColors.primary,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.only(
          top: (1 * Decorators.fontSize),
          bottom: (1 * Decorators.fontSize),
          right: (1 * Decorators.fontSize),
          left: (1 * Decorators.fontSize),
        ),
        hintStyle: TextStyle(color: SmartAssistantColors.grey60),
        fillColor: SmartAssistantColors.black,
        border: Decorators.defaultLightBorder,
        enabledBorder: Decorators.enabledLightBorder,
        focusedBorder: Decorators.focusedLightBorder,
        focusedErrorBorder: Decorators.focusedErrorLightBorder,
        disabledBorder: Decorators.disabledLightBorder,
      ));

  static final ThemeData darkTheme = ThemeData(
      primaryColor: SmartAssistantColors.primary,
      scaffoldBackgroundColor: SmartAssistantColors.black,
      splashColor: Colors.transparent,
      brightness: Brightness.dark,
      highlightColor: Colors.transparent,
      dividerColor: Colors.transparent,
      fontFamily: 'Verdana',
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        showUnselectedLabels: true,
        backgroundColor: SmartAssistantColors.white,
        selectedItemColor: SmartAssistantColors.primary,
        type: BottomNavigationBarType.fixed,
      ),
      inputDecorationTheme: InputDecorationTheme(
        contentPadding: const EdgeInsets.only(
          top: (1 * Decorators.fontSize),
          bottom: (1 * Decorators.fontSize),
          right: (1 * Decorators.fontSize),
          left: (1 * Decorators.fontSize),
        ),
        hintStyle: TextStyle(color: SmartAssistantColors.white),
        fillColor: SmartAssistantColors.black,
        border: Decorators.defaultLightBorder,
        enabledBorder: Decorators.enabledLightBorder,
        focusedBorder: Decorators.focusedLightBorder,
        focusedErrorBorder: Decorators.focusedErrorLightBorder,
        disabledBorder: Decorators.disabledLightBorder,
      ));
}
