import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final largeFont = GoogleFonts.rubik(fontSize: 30);
final mediumFont = GoogleFonts.rubik(fontSize: 14);
final smallFont = GoogleFonts.rubik(fontSize: 12);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 0, 79, 104),

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
    bodyMedium: GoogleFonts.rubik(
      fontSize: 12,
    ),
    displaySmall: GoogleFonts.rubik(
      fontSize: 10,
    ),

    headlineLarge: GoogleFonts.rubik(
      fontSize: 20,
    ),

    bodyLarge: GoogleFonts.rubik(
      fontSize: 16,
    ),

    headlineSmall: GoogleFonts.rubik(
      fontSize: 14,
    ),

    bodySmall: GoogleFonts.rubik(
      fontSize: 12,
    ),

    headlineMedium: GoogleFonts.rubik(
      fontSize: 16,
    ),


    
    
  ),
  appBarTheme: const AppBarTheme(
    scrolledUnderElevation: 0

  ),
  chipTheme: ChipThemeData(
    backgroundColor: Color.fromRGBO(255, 230, 218, 1),
    labelStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,

    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),

  cardColor:  Color.fromARGB(255, 0, 79, 104),
  cardTheme: CardTheme(
    color: Color.fromARGB(255, 106, 136, 207),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(
        color: Color.fromARGB(255, 220, 220, 220), // Softer border color
        width: 0.5,
      ),
    ),
  ),
);
  