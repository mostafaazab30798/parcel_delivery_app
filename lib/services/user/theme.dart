// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

ThemeData userTheme(BuildContext context) {
  try {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final textScale = MediaQuery.textScalerOf(context).scale(1.0);

    double responsiveFont(double baseSize) {
      return baseSize *
          (screenWidth < 400
              ? 0.9
              : screenWidth > 600
                  ? 1.1
                  : 1.0) *
          textScale;
    }

    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFDF7ED),
      primaryColor: const Color(0xFF9B652E),
      canvasColor: const Color(0xFF5D3891),
      cardColor: const Color(0xFFFFFAF3),
      dividerColor: const Color(0xFFE0E0E0),
      highlightColor: const Color(0xFF1F3C88),
      secondaryHeaderColor: const Color(0xFF2E3191),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF9B652E),
        toolbarHeight: screenHeight * 0.1,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ),
        ),
        titleTextStyle: GoogleFonts.alexandria(
          color: const Color(0xFFFFFAF3),
          fontSize: responsiveFont(24),
          fontWeight: FontWeight.w600,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      textTheme: TextTheme(
        displaySmall: GoogleFonts.cairo(
          color: const Color(0xFF222831),
          fontWeight: FontWeight.normal,
          fontSize: responsiveFont(16),
        ),
        displayMedium: GoogleFonts.alexandria(
          color: const Color(0xFF222831),
          fontWeight: FontWeight.w400,
          fontSize: responsiveFont(18),
        ),
        displayLarge: TextStyle(
          fontFamily: 'GE',
          color: const Color(0xFF8B572A),
          fontSize: responsiveFont(34),
        ),
        bodyLarge: GoogleFonts.cairo(
          color: const Color(0xFF222831),
          fontWeight: FontWeight.bold,
          fontSize: responsiveFont(20),
        ),
        bodyMedium: GoogleFonts.cairo(
          //fontFamily: 'Dubai-Regular',
          color: const Color(0xFF8B572A),
          fontSize: responsiveFont(16),
        ),
        bodySmall: GoogleFonts.alexandria(
          //fontFamily: 'Dubai-Regular',
          color: const Color(0xFF4A4A4A),
          //fontWeight: FontWeight.w500,
          fontSize: responsiveFont(17),
        ),
      ),
    );
  } catch (e) {
    print('Error creating user theme: $e');
    // Return a basic theme if there's an error
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: const Color(0xFFFDF7ED),
      primaryColor: const Color(0xFF9B652E),
      cardColor: const Color(0xFFFFFAF3),
    );
  }
}
