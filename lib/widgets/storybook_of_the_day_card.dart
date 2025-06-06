import 'package:flutter/material.dart';
import '../models/storybook.dart';
import '../shared/theme.dart' as app_theme;

class StorybookOfTheDayCard extends StatelessWidget {
  final Storybook storybook;

  const StorybookOfTheDayCard({super.key, required this.storybook});

  @override
  Widget build(BuildContext context) {
    // This is the outer container with the light background and rounded corners
    return Container(
      decoration: BoxDecoration(
        color: app_theme.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius * 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Part 1: The Image with overlayed text
          _buildImageStack(),
          // Part 2: The stats row below the image
          _buildStatsRow(),
        ],
      ),
    );
  }

  // Widget for the Image, Gradient, and Title/Author Text
  Widget _buildImageStack() {
    return Stack(
      children: [
        // ClipRRect gives the image rounded corners
        ClipRRect(
          borderRadius: BorderRadius.circular(app_theme.defaultRadius * 1.5),
          child: Image.asset(
            storybook.imageUrl,
            height: 180, // Adjusted height
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                  height: 180,
                  width: double.infinity,
                  color: Colors.grey[400],
                  child: Icon(Icons.broken_image,
                      size: 50, color: Colors.grey[600]));
            },
          ),
        ),
        // Gradient overlay for text readability
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(app_theme.defaultRadius * 1.5),
            gradient: LinearGradient(
              colors: [
                app_theme.kBlackColor.withOpacity(0.7),
                app_theme.kBlackColor.withOpacity(0.0)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.center,
            ),
          ),
        ),
        // Positioned Title and Author text
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                storybook.title,
                style: app_theme.whiteTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: app_theme.bold,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                storybook.author,
                style: app_theme.whiteTextStyle.copyWith(
                  color: app_theme.kWhiteColor.withOpacity(0.8),
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Widget for the Views and Rating stats
  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
      child: Row(
        children: [
          Icon(
            Icons.remove_red_eye,
            color: app_theme.kBlackColor.withOpacity(0.6),
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            storybook.views,
            style: app_theme.primaryTextStyle.copyWith(
              color: app_theme.kBlackColor.withOpacity(0.8),
              fontWeight: app_theme.medium,
            ),
          ),
          const SizedBox(width: 20),
          Icon(
            Icons.star,
            color: app_theme.kSecondaryColor, // Yellow star color
            size: 16,
          ),
          const SizedBox(width: 6),
          Text(
            "${storybook.rating}/5.0",
            style: app_theme.primaryTextStyle.copyWith(
              color: app_theme.kBlackColor.withOpacity(0.8),
              fontWeight: app_theme.medium,
            ),
          ),
        ],
      ),
    );
  }
}