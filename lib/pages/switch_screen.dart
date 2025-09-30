import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class SwitchScreen extends StatelessWidget {
  const SwitchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;

    final padding = screenSize.width * (isSmallScreen ? 0.02 : 0.03);
    final fontSize = screenSize.width * (isSmallScreen ? 0.04 : 0.045);

    final borderRadius = screenSize.width * (isSmallScreen ? 0.03 : 0.04);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => context.go('/driver-home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 5,
                  vertical: padding * 2.5,
                ),
              ),
              child: Text(
                'واجهة السائق',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize * 1.1,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.go('/user-home'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.withOpacity(0.8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 5,
                  vertical: padding * 2.5,
                ),
              ),
              child: Text(
                'واجهة المستخدم',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize * 1.1,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.go('/api-test'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.withOpacity(0.8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 5,
                  vertical: padding * 2.5,
                ),
              ),
              child: Text(
                'API Test',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize * 1.1,
                ),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => context.go('/test-integration'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.withOpacity(0.8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(borderRadius),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: padding * 5,
                  vertical: padding * 2.5,
                ),
              ),
              child: Text(
                'Test Integration',
                style: GoogleFonts.almarai(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize * 1.1,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
