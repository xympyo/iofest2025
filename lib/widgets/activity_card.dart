// lib/widgets/activity_card.dart
import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class ActivityCard extends StatelessWidget {
  const ActivityCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: app_theme.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius),
      ),
      child: Column(
        children: [
          Text(
            'Or explore quick 5 minutes activity?',
            style: app_theme.blackTextStyle
                .copyWith(fontSize: 16, fontWeight: app_theme.bold),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.auto_stories_outlined,
                  size: 50, color: app_theme.kPrimaryColor),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Just 5 minutes together.',
                        style: app_theme.blackTextStyle
                            .copyWith(fontWeight: app_theme.bold)),
                    const SizedBox(height: 4),
                    Text('Can be more valuable than you think.',
                        style: app_theme.primaryTextStyle.copyWith(
                            color: app_theme.kBlackColor.withOpacity(0.7))),
                  ],
                ),
              )
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
                backgroundColor: app_theme.kPrimaryColor,
                foregroundColor: app_theme.kWhiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(app_theme.defaultRadius),
                )),
            child: const Text('Little Things Matter'),
          )
        ],
      ),
    );
  }
}