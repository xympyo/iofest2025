// lib/widgets/genre_selector.dart
import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class GenreSelector extends StatelessWidget {
  final List<String> genres;
  final int selectedIndex;
  final Function(int) onGenreSelected;

  const GenreSelector({
    super.key,
    required this.genres,
    required this.selectedIndex,
    required this.onGenreSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: genres.length,
        padding: EdgeInsets.only(left: app_theme.defaultMargin),
        itemBuilder: (context, index) {
          bool isSelected = selectedIndex == index;
          return GestureDetector(
            onTap: () => onGenreSelected(index),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? app_theme.kPrimaryColor
                    : app_theme.kPrimaryLightColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                genres[index],
                style: (isSelected
                        ? app_theme.whiteTextStyle
                        : app_theme.primaryTextStyle)
                    .copyWith(
                        fontWeight: app_theme.medium,
                        color: isSelected
                            ? app_theme.kWhiteColor
                            : app_theme.kPrimaryColor),
              ),
            ),
          );
        },
      ),
    );
  }
}