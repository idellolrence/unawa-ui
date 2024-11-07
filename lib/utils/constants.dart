import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts

class AppTheme {
  // UNAWA COLOR PALETTE

  static const Color mainColor = Color(0xFF004AAD); // Main Color
  static const Color secondColor = Color(0xFFF47500); // Orange
  static const Color accentColor = Color(0xFF79159D); // Purple
  static const Color lightBackgroundColor =
      Color(0xFFDFE3EE); // Light background color

  // Dark mode color constants
  static const Color darkBackgroundColor =
      Color(0xFF18191A); // Darker background
  static const Color cardColor = Color(0xFF242526); // Card background
  static const Color highlightColor = Color(0xFF3A3B3C); // Highlight color
  static const Color textColor = Color(0xFFE4E6EB); // Text color
  static const Color secondaryTextColor =
      Color(0xFFB0B3B8); // Secondary text color
  static const Color disabledColor =
      Color(0xFFA0A0A0); // Disabled color for icons and buttons

  // Font constants
  static TextStyle bodyTextStyleLight = GoogleFonts.poppins(
    color: darkBackgroundColor,
    fontSize: 16,
  );

  static TextStyle bodyTextStyleDark = GoogleFonts.poppins(
    color: textColor,
    fontSize: 16,
  );

  // Card style constants
  static BoxDecoration cardDecoration = BoxDecoration(
    borderRadius: BorderRadius.circular(15),
  );

  // Define theme data
  static ThemeData lightTheme = ThemeData(
    primaryColor: mainColor,
    hintColor: lightBackgroundColor,
    scaffoldBackgroundColor: lightBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: mainColor,
      iconTheme: IconThemeData(color: Colors.white),
      titleTextStyle: TextStyle(color: Colors.white, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mainColor,
      selectedItemColor: Colors.white,
      unselectedItemColor: Colors.grey,
    ),
    textTheme: TextTheme(
      bodyLarge: bodyTextStyleLight,
      bodyMedium: bodyTextStyleLight.copyWith(color: Colors.black54),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    primaryColor: mainColor,
    hintColor: secondColor,
    scaffoldBackgroundColor: darkBackgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: mainColor,
      iconTheme: IconThemeData(color: textColor),
      titleTextStyle: TextStyle(color: textColor, fontSize: 20),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: mainColor,
      selectedItemColor: highlightColor,
      unselectedItemColor: secondaryTextColor,
    ),
    cardColor: cardColor, // Softer card background color
    textTheme: TextTheme(
      bodyLarge: bodyTextStyleDark,
      bodyMedium: bodyTextStyleDark.copyWith(color: secondaryTextColor),
    ),
  );
}
