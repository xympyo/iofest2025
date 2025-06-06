import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class FavoriteGenreList extends StatelessWidget {
  final List<Map<String, dynamic>> favoriteGenres;

  const FavoriteGenreList({super.key, required this.favoriteGenres});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: favoriteGenres.length,
        padding: EdgeInsets.only(left: app_theme.defaultMargin),
        itemBuilder: (context, index) {
          final genre = favoriteGenres[index];
          return Container(
            width: 110,
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
                color: app_theme.kPrimaryLightColor,
                borderRadius: BorderRadius.circular(app_theme.defaultRadius)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(genre['icon'], size: 40, color: app_theme.kPrimaryColor),
                
                // CHANGED: Replaced Spacer with a SizedBox for controlled spacing
                const SizedBox(height: 8), 
                
                Text(genre['title'],
                    style: app_theme.primaryTextStyle.copyWith(
                        fontWeight: app_theme.semiBold,
                        color: app_theme.kPrimaryColor)),
              ],
            ),
          );
        },
      ),
    );
  }
}