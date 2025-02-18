import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

final largeFont = GoogleFonts.rubik(fontSize: 30);
final mediumFont = GoogleFonts.rubik(fontSize: 14);
final smallFont = GoogleFonts.rubik(fontSize: 12);

final ThemeData appTheme = ThemeData(
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 18, 57, 78),
    tertiaryFixed: const Color.fromARGB(255, 236, 116, 18),
    secondaryFixed: const Color.fromARGB(255, 195, 225, 240),

    error: const Color.fromARGB(255, 255, 0, 0),

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
  appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color.fromARGB(255, 53, 99, 135),

      foregroundColor: Colors.white, // White text
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
    ),
  ),
tabBarTheme: TabBarTheme(
    unselectedLabelStyle: const TextStyle(
      color: Color.fromARGB(255, 251, 196, 151),
    ),
    labelColor: Color.fromARGB(255, 218, 178, 171),
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: const Color.fromARGB(255, 252, 202, 155),
      border: Border.all(color: Colors.black, width: 0.5),
    ),
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color.fromARGB(255, 255, 229, 221),
    behavior: SnackBarBehavior.floating,
    elevation: 8,
    contentTextStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,
    ),
  ),
  chipTheme: ChipThemeData(
    backgroundColor: const Color.fromARGB(255, 255, 228, 220),
    labelStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  ),

    badgeTheme: BadgeThemeData(
    backgroundColor: const Color.fromARGB(255, 181, 71, 16),
    textStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,
    ),
  ),

 
  cardTheme: CardTheme(
    color: const Color.fromARGB(255, 234, 240, 255),
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
    splashColor: Colors.transparent,
    highlightColor: Colors.transparent,
    hoverColor: Colors.transparent,
  useMaterial3: true,

  // Define the default brightness and colors.
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color.fromARGB(255, 111, 118, 124),
    surface: const Color.fromARGB(255, 28, 27, 27),
    onSurface: const Color.fromARGB(255, 255, 255, 255),
    tertiaryFixed: const Color.fromARGB(255, 236, 116, 18),
    error: const Color.fromARGB(255, 177, 10, 66),
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
  appBarTheme: const AppBarTheme(scrolledUnderElevation: 0),

  tabBarTheme: TabBarTheme(
    unselectedLabelStyle: const TextStyle(
      color: Color.fromARGB(255, 155, 155, 155),
    ),
    labelColor: Color.fromARGB(255, 163, 54, 11),
    indicatorSize: TabBarIndicatorSize.tab,
    indicator: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: const Color.fromARGB(255, 63, 97, 116),
      border: Border.all(color: Colors.black, width: 0.5),
    ),
  ),

  cardTheme: CardTheme(
    color: const Color.fromARGB(255, 42, 53, 70),
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

  switchTheme: SwitchThemeData(
    thumbColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        return const Color.fromARGB(255, 100, 100, 100); // Dark grey when off
      },
    ),
    trackColor: WidgetStateProperty.resolveWith<Color>(
      (Set<WidgetState> states) {
        if (states.contains(WidgetState.selected)) {
          return const Color.fromARGB(
              255, 211, 91, 0); // Light orange track when on
        }
        return const Color.fromARGB(255, 150, 150, 150); // Grey track when off
      },
    ),
  ),

  snackBarTheme: SnackBarThemeData(
    backgroundColor: const Color.fromARGB(255, 255, 201, 135),
    behavior: SnackBarBehavior.floating,
    elevation: 8,
    contentTextStyle: GoogleFonts.rubik(
      fontSize: 12,
      color: Colors.black,
    ),
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: const Color.fromARGB(255, 131, 109, 64),
    foregroundColor: Colors.white,
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
  backgroundColor:  const Color.fromARGB(255, 85, 95, 102),
    foregroundColor: Colors.white, // White text
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
  ),
),

  chipTheme: ChipThemeData(
    backgroundColor: const Color.fromARGB(255, 65, 57, 54),
    labelStyle: GoogleFonts.rubik(
      fontSize: kIsWeb ? 14 : 12,
      fontWeight: FontWeight.w400,
               

      color: Colors.white,

    ),
   shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(
                      kIsWeb ? 12 : 10), // Adjust rounding for web
                ),
  ),
);
