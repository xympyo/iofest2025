import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      child: Text(
        title,
        style: app_theme.blackTextStyle.copyWith(
          fontSize: 20,
          fontWeight: app_theme.bold,
        ),
      ),
    );
  }
}