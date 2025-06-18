import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_fonts/google_fonts.dart'; // Import GoogleFonts
import 'login_screen.dart';
import '../shared/theme.dart' as app_theme;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Use kTriaryColor for the light pink background from the image,
      // or kPrimaryLightColor if you prefer the previous lavender.
      backgroundColor: app_theme.kTriaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/Artboard 1@4xActualLogo 1.png',
              height: 150,
              // width: 150,
            ),
            const SizedBox(height: 24), // Adjusted spacing a bit
            Text(
              'TappyTale',
              style: GoogleFonts.montserrat(
                color: app_theme.kSecondaryColor,
                fontSize: 32,
                fontWeight: app_theme.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
