import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class ActivityInfoCard extends StatelessWidget {
  final String category;
  final String iconPath;
  final String title;
  final String description;
  final Color backgroundColor;
  final double width;
  final double height;
  final bool isLoading;

  const ActivityInfoCard({
    super.key,
    required this.category,
    required this.iconPath,
    required this.title,
    required this.description,
    this.backgroundColor = const Color(0xffFCEEEC),
    this.width = 280,
    this.height = 400,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      width: width,
      height: height,
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
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: IntrinsicHeight(
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
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}