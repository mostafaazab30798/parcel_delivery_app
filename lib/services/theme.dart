// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData driverTheme() {
  return ThemeData(
    cardColor: Color.fromARGB(255, 255, 255, 255),
    secondaryHeaderColor: Color(0xFF2E3191),
    canvasColor: Color(0xFF2E3191),
    primaryColor: Color(0xFFF47B20),
    scaffoldBackgroundColor: Color(0xFFF8F9FB),
    dividerColor: Color(0xFFE0E0E0),
    textTheme: TextTheme(
      displaySmall: GoogleFonts.almarai(
        color: Color(0xFF2E3191),
        fontWeight: FontWeight.normal,
        fontSize: 15,
      ),
      displayMedium: GoogleFonts.cairo(
        color: Color.fromARGB(255, 255, 255, 255),
        fontWeight: FontWeight.w400,
        fontSize: 18,
      ),
      displayLarge: GoogleFonts.cairo(
        color: Color(0xFF2E3191),
        //fontWeight: FontWeight.bold,
        fontSize: 34,
      ),
      bodyLarge: GoogleFonts.notoSansArabic(
        color: Color.fromARGB(255, 39, 40, 48),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
      bodyMedium: GoogleFonts.cairo(
        color: Color(0xFF2E3191),
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      bodySmall: GoogleFonts.notoNaskhArabic(
        color: Color(0xFF2E3191),
        fontWeight: FontWeight.normal,
        fontSize: 18,
      ),
    ),
  );
}
