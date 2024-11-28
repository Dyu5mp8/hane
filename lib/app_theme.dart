import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final largeFont = GoogleFonts.rubik(fontSize: 30);
final mediumFont = GoogleFonts.rubik(fontSize: 14);
final smallFont = GoogleFonts.rubik(fontSize: 12);

final ThemeData appTheme = ThemeData(
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 0, 2, 3),

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
    backgroundColor: const Color.fromRGBO(255, 230, 218, 1),
    labelStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,

    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
  
  cardColor:  const Color.fromARGB(255, 0, 79, 104),
  cardTheme: CardTheme(
    color: const Color.fromARGB(255, 106, 136, 207),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),
      side: const BorderSide(
        color: Color.fromARGB(255, 220, 220, 220), // Softer border color
        width: 0.5,
      ),
    ),
  ),
);
  
final ThemeData darkAppTheme = ThemeData(
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 23, 23, 23),
    surface: const Color.fromARGB(255, 32, 32, 32),
    onSurface: const Color.fromARGB(255, 202, 202, 202),

    // ···
    brightness: Brightness.dark,
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

  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: const TextStyle(
      color: Color.fromARGB(255, 155, 155, 155),
    ),
    labelColor: Color.fromARGB(255, 231, 231, 231),

    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: const Color.fromARGB(255, 181, 71, 16),
      border: Border.all(color: Colors.black, width: 0.5),
    ),
  ),

  cardTheme: CardTheme(
    color: const Color.fromARGB(255, 117, 117, 117),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12.0),

    ),
  ),
  badgeTheme: BadgeThemeData(
    backgroundColor: const Color.fromARGB(255, 181, 71, 16),
    textStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,
    ),

  
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color.fromARGB(255, 181, 71, 16),
    labelStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,

    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),
);
