import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class ActivityInfoCard extends StatelessWidget {
  // These will be the properties you fetch from your database
  final String category;
  final String iconPath;
  final String title;
  final String description;
  final Color backgroundColor;

  const ActivityInfoCard({
    super.key,
    required this.category,
    required this.iconPath,
    required this.title,
    required this.description,
    this.backgroundColor = const Color(0xffFCEEEC), // Default pinkish color
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 280, // A fixed width for the card
      height: 400, // A fixed height for the card
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius * 1.5),
      ),
      // Using ClipRRect to make sure the background image respects the border radius
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // The wavy background image
          Positioned(
            bottom: -30, // Positioned to bleed off the bottom
            left: -20,
            right: -20,
            child: Image.asset('assets/images/Intersect.png'),
          ),

          // The main content of the card
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                Text(
                  category,
                  style: app_theme.teksTextStyle.copyWith(
                    fontSize: 20,
                    fontWeight: app_theme.bold,
                  ),
                ),
                const SizedBox(height: 18),
                Image.asset(
                  iconPath,
                  height: 90,
                  width: 90,
                ),
                const Spacer(), // Pushes the text box to the bottom
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: app_theme.kWhiteColor.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(app_theme.defaultRadius),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: app_theme.teksTextStyle.copyWith(
                          fontSize: 18,
                          fontWeight: app_theme.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: app_theme.teksTextStyle.copyWith(
                          fontSize: 14,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}