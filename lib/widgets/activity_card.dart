import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;
import 'package:iofest/screens/quick_activity_screen.dart';

class ActivityCard extends StatelessWidget {
  final VoidCallback? onQuickActivityTap;
  const ActivityCard({super.key, this.onQuickActivityTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      padding: const EdgeInsets.all(20), // Slightly reduced padding
      decoration: BoxDecoration(
        color: app_theme.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/images/cards.png',
            width: 75,
            height: 75,
          ),
          const SizedBox(width: 30),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // This ensures the text/button group is vertically centered
              // next to the larger icon.
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Just 5 minutes together.',
                  style: app_theme.blackTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: app_theme.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Might be more valuable than you think',
                  style: app_theme.primaryTextStyle.copyWith(
                    color: app_theme.kBlackColor.withOpacity(0.7),
                  ),
                ),
                const SizedBox(height: 16),
                // Custom button to match the UI design
                GestureDetector(
                  onTap: () {
                    if (onQuickActivityTap != null) {
                      onQuickActivityTap!();
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 16,
                    ),
                    decoration: BoxDecoration(
                      color: app_theme.kPrimaryColor,
                      borderRadius:
                          BorderRadius.circular(app_theme.defaultRadius),
                      boxShadow: [
                        BoxShadow(
                          color: app_theme.kPrimaryColor.withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        )
                      ],
                    ),
                    child: Center(
                      child: Text(
                        'Little Things Matter',
                        style: app_theme.whiteTextStyle
                            .copyWith(fontWeight: app_theme.semiBold),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
