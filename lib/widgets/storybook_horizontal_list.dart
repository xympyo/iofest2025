import 'package:flutter/material.dart';
import '../models/storybook.dart';
import '../widgets/story_card.dart';
import '../shared/theme.dart' as app_theme;

class StorybookHorizontalList extends StatelessWidget {
  final List<Storybook> storybooks;

  const StorybookHorizontalList(this.storybooks, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 230,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: storybooks.length,
        padding: EdgeInsets.only(left: app_theme.defaultMargin),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 16),
            child: StoryCard(storybook: storybooks[index]),
          );
        },
      ),
    );
  }
}