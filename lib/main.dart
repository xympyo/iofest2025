// main.dart
import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'shared/theme.dart' as app_theme; // Import your theme

import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'dart:io';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print('Current directory: ' + Directory.current.path);
  print('Files:');
  Directory.current.listSync().forEach((f) => print(f.path));
  runApp(const TappyTaleApp());
}

class TappyTaleApp extends StatelessWidget {
  const TappyTaleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TappyTale',
      theme: ThemeData(
        // Use a color from your theme for primarySwatch, or create a MaterialColor
        // For simplicity, I'll use kPrimaryColor to generate a swatch.
        // You might want to create a full MaterialColor for better results.
        primarySwatch: MaterialColor(
          app_theme.kPrimaryColor.value,
          <int, Color>{
            50: app_theme.kPrimaryColor.withOpacity(0.1),
            100: app_theme.kPrimaryColor.withOpacity(0.2),
            200: app_theme.kPrimaryColor.withOpacity(0.3),
            300: app_theme.kPrimaryColor.withOpacity(0.4),
            400: app_theme.kPrimaryColor.withOpacity(0.5),
            500: app_theme.kPrimaryColor.withOpacity(0.6),
            600: app_theme.kPrimaryColor.withOpacity(0.7),
            700: app_theme.kPrimaryColor.withOpacity(0.8),
            800: app_theme.kPrimaryColor.withOpacity(0.9),
            900: app_theme.kPrimaryColor.withOpacity(1.0),
          },
        ),
        scaffoldBackgroundColor:
            app_theme.kPrimaryLightColor, // Light background
        fontFamily: 'Poppins', // Matches GoogleFonts.poppins
        textTheme: TextTheme(
          // Define some global text styles if needed, or apply directly
          headlineLarge: app_theme.blackTextStyle
              .copyWith(fontSize: 30, fontWeight: app_theme.bold),
          headlineMedium: app_theme.blackTextStyle
              .copyWith(fontSize: 22, fontWeight: app_theme.bold),
          headlineSmall: app_theme.blackTextStyle
              .copyWith(fontSize: 18, fontWeight: app_theme.semiBold),
          bodyLarge: app_theme.primaryTextStyle.copyWith(fontSize: 16),
          bodyMedium: app_theme.primaryTextStyle.copyWith(fontSize: 14),
          labelLarge: app_theme.whiteTextStyle.copyWith(
              fontSize: 16, fontWeight: app_theme.semiBold), // For buttons
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor:
              app_theme.kPrimaryLightColor, // Light background for inputs
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(app_theme.defaultRadius),
            borderSide: BorderSide.none,
          ),
          hintStyle: app_theme.primaryTextStyle.copyWith(
              color: app_theme.kBlackColor.withOpacity(0.5), fontSize: 15),
          prefixIconColor: app_theme.kBlackColor.withOpacity(0.5),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: app_theme
                .kBlackColor, // Using kBlackColor for primary button BG
            foregroundColor:
                app_theme.kWhiteColor, // Text color for primary button
            padding: EdgeInsets.symmetric(
                vertical: 16.0, horizontal: app_theme.defaultMargin / 2),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(app_theme.defaultRadius),
            ),
            textStyle: app_theme.whiteTextStyle
                .copyWith(fontSize: 16, fontWeight: app_theme.semiBold),
          ),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
