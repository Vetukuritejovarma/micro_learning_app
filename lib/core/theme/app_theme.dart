import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      brightness: Brightness.light,
      textTheme: GoogleFonts.spaceGroteskTextTheme(),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1B5EFF),
        secondary: Color(0xFFFF8A3D),
        surface: Color(0xFFF4F4F7),
        onSurface: Color(0xFF1B1B1F),
      ),
      scaffoldBackgroundColor: const Color(0xFFF6F5F2),
      useMaterial3: true,
    );
  }
}
