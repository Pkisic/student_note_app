import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTheme {
  static TextTheme lightTextTheme = TextTheme(
    bodyLarge: GoogleFonts.playfairDisplay(
      fontSize: 42.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.playfairDisplay(
      fontSize: 30.0,
      fontWeight: FontWeight.w300,
      color: Colors.black,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    titleLarge: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
  );

  static TextTheme darkTextTheme = TextTheme(
    bodyLarge: GoogleFonts.montserrat(
      fontSize: 30.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    bodyMedium: GoogleFonts.montserrat(
      fontSize: 15.0,
      fontWeight: FontWeight.w300,
      color: Colors.white,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 32.0,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 21.0,
      fontWeight: FontWeight.w700,
      color: Colors.white,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
    titleLarge: GoogleFonts.openSans(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.white,
    ),
  );

  static ThemeData dark() {
    return ThemeData(
      brightness: Brightness.dark,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith((states) {
          return Colors.black;
        }),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: Colors.orange[900],
      ),
      textTheme: darkTextTheme,
      scaffoldBackgroundColor: Colors.black,
      // pageTransitionsTheme: const PageTransitionsTheme(builders: {
      //   TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
      // }),
    );
  }
}
