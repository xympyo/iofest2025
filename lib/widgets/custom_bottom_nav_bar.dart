import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: app_theme.kWhiteColor,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(app_theme.defaultRadius * 1.5),
            topRight: Radius.circular(app_theme.defaultRadius * 1.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(app_theme.defaultRadius * 1.5),
          topRight: Radius.circular(app_theme.defaultRadius * 1.5),
        ),
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: app_theme.kWhiteColor,
          selectedItemColor: app_theme.kPrimaryColor, // Selected icon color
          unselectedItemColor:
              app_theme.kBlackColor.withOpacity(0.4), // Unselected icon color
          showSelectedLabels: false,
          showUnselectedLabels: false,
          elevation: 0,
          items: [
            _buildNavItem(Icons.menu_book_outlined, Icons.menu_book, 0,
                currentIndex, context),
            _buildNavItem(Icons.filter_none_outlined, Icons.filter_none, 1,
                currentIndex, context),
            _buildNavItem(Icons.add_circle_outline, Icons.add_circle, 2,
                currentIndex, context,
                isCentral: true),
            _buildNavItem(Icons.history_outlined, Icons.history, 3,
                currentIndex, context),
            _buildNavItem(Icons.grid_view_outlined, Icons.grid_view, 4,
                currentIndex, context),
          ],
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem(IconData outlinedIcon,
      IconData filledIcon, int index, int currentIndex, BuildContext context,
      {bool isCentral = false}) {
    double iconSize = isCentral ? 32 : 26;
    Color iconColor = currentIndex == index
        ? app_theme.kPrimaryColor
        : app_theme.kBlackColor.withOpacity(0.4);

    if (isCentral && currentIndex == index) {
      // Central active button style
      return BottomNavigationBarItem(
        icon: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: app_theme.kPrimaryColor.withOpacity(0.15),
            shape: BoxShape.circle,
          ),
          child:
              Icon(filledIcon, size: iconSize, color: app_theme.kPrimaryColor),
        ),
        label: '',
      );
    }

    return BottomNavigationBarItem(
      icon: Icon(currentIndex == index ? filledIcon : outlinedIcon,
          size: iconSize, color: iconColor),
      label: '',
    );
  }
}
