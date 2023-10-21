import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '/../utils/Colors.dart';
import '/../main.dart';
import '/../utils/Constants.dart';
import 'package:nb_utils/nb_utils.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData lightTheme = ThemeData(
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: primaryColor,
    hoverColor: Colors.grey,
    fontFamily: GoogleFonts.poppins().fontFamily,
    appBarTheme: AppBarTheme(
      color: primaryColor,
      iconTheme: IconThemeData(color: Colors.white),
    ),
    cardColor: backgroundColor,
    cardTheme: CardTheme(
      color: Colors.white,
    ),
    iconTheme: IconThemeData(color: textPrimaryColour),
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Color(0xFFF6F8FB)),
      bodyLarge: TextStyle(color: primaryColor),
      titleMedium: TextStyle(color: textSecondaryColour),
      titleSmall: TextStyle(color: textPrimaryColour),
    ), colorScheme: ColorScheme.light(
      primary: primaryColor!,
      onPrimary: colorAccent!,
      surface: Colors.white,
      secondary: colorAccent!,
      background: itemBackgroundColor,
    ).copyWith(error: Colors.red),
  );

  static final ThemeData darkTheme = ThemeData(
    scaffoldBackgroundColor: Color(0xFF222222),
    appBarTheme: AppBarTheme(
      color: primaryColor,
      iconTheme: IconThemeData(color: Color(0xFF1D2939)),
    ),
    cardColor: Color(0xFF1D2939),
    primaryColor: isHalloween ? white : primaryColor,
    hoverColor: Colors.black,
    fontFamily: GoogleFonts.poppins().fontFamily,
    cardTheme: CardTheme(
      color: Color(0xFF2b2b2b),
    ),
    iconTheme: IconThemeData(color: Colors.white70),
    textTheme: TextTheme(
      headlineMedium: TextStyle(color: Color(0xFF1D2939)),
      bodyLarge: TextStyle(color: Colors.white70),
      titleMedium: TextStyle(color: Colors.white70),
      titleSmall: TextStyle(color: Colors.white54),
    ), colorScheme: ColorScheme.light(
      background: Color(0xFF1D2939),
      primary: Color(0xFF131d25),
      onPrimary: Color(0xFF1D2939),
      surface: Color(0xFF1D2939),
      onSecondary: Colors.white,
      secondary: white,
    ).copyWith(error: Color(0xFFCF6676)),
  );
}
