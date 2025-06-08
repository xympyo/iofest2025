import 'package:flutter/material.dart';
import 'package:iofest/screens/storybook_detail_screen.dart';
import '../models/storybook.dart';
import '../shared/theme.dart' as app_theme;

class StoryCard extends StatelessWidget {
  final Storybook storybook;
  // We don't need to pass width/height from the outside anymore,
  // as the parent list and the card's content will define it.

  const StoryCard({
    super.key,
    required this.storybook,
  });

  @override
  Widget build(BuildContext context) {
    // The width will be determined by the constraints of the parent list view.
    // Let's define a fixed width here for consistency.
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                StorybookDetailScreen(storybookId: storybook.id),
          ),
        );
      },
      child: SizedBox(
        width: 150, // A good default width for cards
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              elevation: 2.0,
              clipBehavior: Clip.antiAlias,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(app_theme.defaultRadius),
              ),
              child: Image.network(
                storybook.backgroundImage,
                width: 150, // Match the SizedBox width
                height: 155, // A fixed height for the image
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 150,
                    height: 155,
                    color: Colors.grey[300],
                    child: Icon(Icons.image_not_supported,
                        color: Colors.grey[600]),
                  );
                },
              ),
            ),
            // Use Expanded to fill the remaining vertical space
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 4.0, right: 4.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // This helps position the views at the bottom
                  children: [
                    // Title
                    Text(
                      storybook.title,
                      style: app_theme.blackTextStyle.copyWith(
                        fontSize: 15,
                        fontWeight: app_theme.semiBold,
                        height: 1.2, // Tweak line height to prevent overflow
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Views
                    Row(
                      children: [
                        Icon(Icons.visibility_outlined,
                            size: 14,
                            color: app_theme.kBlackColor.withOpacity(0.6)),
                        const SizedBox(width: 4),
                        Text(
                          storybook.readCount.toString(),
                          style: app_theme.primaryTextStyle.copyWith(
                              color: app_theme.kBlackColor.withOpacity(0.6),
                              fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
