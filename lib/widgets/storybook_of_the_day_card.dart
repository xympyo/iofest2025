import 'package:flutter/material.dart';
import '../models/storybook.dart';
import '../shared/theme.dart' as app_theme;

class StorybookOfTheDayCard extends StatelessWidget {
  final Storybook storybook;

  const StorybookOfTheDayCard({super.key, required this.storybook});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: app_theme.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius * 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          // CHANGED: Wrapped the image stack in Padding for the margin
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: _buildImageStack(),
          ),
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Text(
        'Storybook of the day',
        style: app_theme.blackTextStyle.copyWith(
          fontSize: 18,
          fontWeight: app_theme.bold,
        ),
      ),
    );
  }

  Widget _buildImageStack() {
    return Stack(
      children: [
        // CHANGED: Wrapped the Image and Gradient in ClipRRect for rounded corners
        ClipRRect(
          borderRadius: BorderRadius.circular(app_theme.defaultRadius),
          child: Stack(
            children: [
              Image.asset(
                storybook.imageUrl,
                height: 180,
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
              // Gradient overlay for text readability
              Container(
                height: 180,
                width: double.infinity,
                decoration: BoxDecoration(
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
            ],
          ),
        ),
        // Positioned Title and Author text (this stays outside the ClipRRect to avoid being clipped)
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

  Widget _buildStatsRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
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