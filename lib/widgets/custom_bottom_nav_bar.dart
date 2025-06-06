// lib/widgets/custom_bottom_nav_bar.dart
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
    return SizedBox(
      height: 85,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: app_theme.kPrimaryLightColor,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),

              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0), // <-- CHANGED
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _buildNavItem('assets/images/read.png', 0),
                    _buildNavItem('assets/images/cards.png', 1),
                    const SizedBox(width: 50),
                    _buildNavItem('assets/images/piechart2.png', 3),
                    _buildNavItem('assets/images/dashboard.png', 4),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: _buildCentralNavItem('assets/images/Group 1381.png', 2),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(String imagePath, int index) {
    bool isSelected = currentIndex == index;
    return GestureDetector(
      onTap: () => onTap(index),
      child: Image.asset(
        imagePath,
        height: 28, 
        width: 28,  
        color: isSelected
            ? app_theme.kBlackColor
            : app_theme.kPrimaryColor.withOpacity(0.6),
        errorBuilder: (context, error, stackTrace) {
          return Icon(Icons.error, color: Colors.red, size: 32); 
        },
      ),
    );
  }

  Widget _buildCentralNavItem(String imagePath, int index) {
    // You can also make the central button and its icon larger if you wish
    // For now, we'll keep it as is, but you could change these values.
    return GestureDetector(
      onTap: () => onTap(index),
      child: Container(
        height: 60,
        width: 60,
        decoration: BoxDecoration(
          color: app_theme.kPrimaryColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: app_theme.kPrimaryColor.withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 8),
            )
          ],
        ),
        child: Center(
          child: Image.asset(
            imagePath,
            height: 32, 
            width: 32,  
          ),
        ),
      ),
    );
  }
}