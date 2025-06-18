import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class ActivityInfoCard extends StatelessWidget {
  // Data properties
  final String category;
  final String title;
  final String description;

  // Design properties
  final Color backgroundColor;
  final String iconPath;
  final String backgroundShapePath; // The new parameter

  // UI state properties
  final double width;
  final double height;
  final bool isLoading;
  final bool showClose;
  final VoidCallback? onClose;

  const ActivityInfoCard({
    super.key,
    required this.category,
    required this.title,
    required this.description,
    required this.backgroundColor,
    required this.iconPath,
    required this.backgroundShapePath,
    this.width = 280,
    this.height = 400,
    this.isLoading = false,
    this.showClose = false,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: width,
        height: height,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius * 1.5),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            bottom: -30,
            left: -20,
            right: -20,
            child: Image.asset(backgroundShapePath), // Uses the new parameter
          ),
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
                const Spacer(),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: app_theme.kWhiteColor.withOpacity(0.7),
                    borderRadius:
                        BorderRadius.circular(app_theme.defaultRadius),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        title,
                        textAlign: TextAlign.center,
                        style: app_theme.teksTextStyle.copyWith(
                          fontSize: 16,
                          fontWeight: app_theme.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        description,
                        textAlign: TextAlign.center,
                        style: app_theme.teksTextStyle.copyWith(
                          fontSize: 12,
                          height: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (showClose)
            Positioned(
              top: 16,
              right: 16,
              child: GestureDetector(
                onTap: onClose,
                child: const Icon(Icons.close, size: 28),
              ),
            ),
        ],
      ),
    );
  }
}
