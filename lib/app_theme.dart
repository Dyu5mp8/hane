import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final largeFont = GoogleFonts.roboto(fontSize: 30);
final mediumFont = GoogleFonts.roboto(fontSize: 14);
final smallFont = GoogleFonts.roboto(fontSize: 12);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Colors.purple,
    // ···
    brightness: Brightness.light,
  ),

  textTheme: TextTheme(
    displayLarge: const TextStyle(
      fontSize: 72,
      fontWeight: FontWeight.bold,
    ),
    // ···
    titleLarge: GoogleFonts.barlowSemiCondensed(
      fontSize: 30,
    ),
    bodyMedium: GoogleFonts.roboto(
      fontSize: 16,
    ),
    displaySmall: GoogleFonts.roboto(
      fontSize: 14,
    ),
  ),
);
  