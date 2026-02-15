import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.light(
      primary: Colors.brown,
      onPrimary: Colors.white,
      secondary: Color(0xFFFFA000),
      onSecondary: Colors.black,
      surface: Colors.white,
      onSurface: Colors.black,
      error: Color(0xFFD32F2F),
      onError: Colors.white,
    ),
    cardColor: Colors.white,
    dividerColor: Colors.grey.shade300,
    scaffoldBackgroundColor: Color(0xFFF5F5F5),
    iconTheme: IconThemeData(color: Colors.brown),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.black),
      bodyMedium: TextStyle(color: Colors.black87),
      bodySmall: TextStyle(color: Colors.black54),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF90CAF9),
      onPrimary: Colors.black,
      secondary: Color(0xFFFFD54F),
      onSecondary: Colors.black,
      surface: Color(0xFF121212),
      onSurface: Colors.white,
      error: Color(0xFFCF6679),
      onError: Colors.black,
    ),
    cardColor: Color(0xFF1E1E1E),
    dividerColor: Colors.grey.shade700,
    scaffoldBackgroundColor: Color(0xFF121212),
    iconTheme: IconThemeData(color: Color(0xFF90CAF9)),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      bodySmall: TextStyle(color: Colors.white60),
    ),
  );
}
