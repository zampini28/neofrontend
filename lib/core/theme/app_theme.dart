import 'package:flutter/material.dart';

class AppTheme {
  
  AppTheme._();

  static final ThemeData light = ThemeData(
    scaffoldBackgroundColor: const Color.fromARGB(255, 221, 224, 228),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color.fromARGB(255, 221, 224, 228),
      centerTitle: true,
    ),
    colorScheme: const ColorScheme.light(
      primary: Color.fromARGB(255, 56, 163, 165),
      secondary: Color.fromARGB(255, 255, 29, 145),
      tertiary: Color.fromARGB(255, 255, 168, 117),
      primaryContainer: Color.fromARGB(255, 236, 236, 236),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(fontFamily: 'Outfit', fontSize: 64, color: _dark),
      displayMedium: TextStyle(fontFamily: 'Outfit', fontSize: 44, color: _dark),
      displaySmall: TextStyle(fontFamily: 'Outfit', fontSize: 36, color: _dark),
      headlineLarge: TextStyle(fontFamily: 'Outfit', fontSize: 32, color: _dark),
      headlineMedium: TextStyle(fontFamily: 'Outfit', fontSize: 24, color: _dark),
      headlineSmall: TextStyle(fontFamily: 'Outfit', fontSize: 24, color: _dark),
      titleLarge: TextStyle(fontFamily: 'Outfit', fontSize: 22, color: _dark),
      titleMedium: TextStyle(fontFamily: 'Poppins', fontSize: 18, color: Colors.white),
      titleSmall: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: Colors.white),
      labelLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: _grey),
      labelMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: _grey),
      labelSmall: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: _grey),
      bodyLarge: TextStyle(fontFamily: 'Poppins', fontSize: 16, color: _dark),
      bodyMedium: TextStyle(fontFamily: 'Poppins', fontSize: 14, color: _dark),
      bodySmall: TextStyle(fontFamily: 'Poppins', fontSize: 12, color: _dark),
    ),
  );

  static const Color _dark = Color.fromARGB(255, 20, 24, 27);
  static const Color _grey = Color.fromARGB(255, 110, 125, 162);
}
