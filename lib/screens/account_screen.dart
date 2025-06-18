import 'package:flutter/material.dart';
import 'edit_profile_screen.dart';
import '../shared/theme.dart' as app_theme;

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background wave
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipPath(
              clipper: WaveClipper(),
              child: Container(
                height: 200,
                color: app_theme.kPrimaryLightColor,
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildHeader(context),
                const SizedBox(height: 30),
                _buildSectionTitle('Account'),
                _buildSettingsTile(
                  title: 'Edit Profile',
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const EditProfileScreen(),
                    ));
                  },
                ),
                _buildSettingsTile(title: 'Help', onTap: () {}),
                _buildSettingsTile(title: 'Website', onTap: () {}),
                const SizedBox(height: 30),
                _buildSectionTitle('General'),
                _buildSettingsTile(title: 'Privacy & Policy', onTap: () {}),
                _buildSettingsTile(title: 'Term of Service', onTap: () {}),
                _buildSettingsTile(title: 'Rate App', onTap: () {}),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Header Section
  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(app_theme.defaultMargin),
      color: app_theme.kPrimaryLightColor,
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Adeliazh',
                  style: app_theme.blackTextStyle.copyWith(
                    fontSize: 24,
                    fontWeight: app_theme.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'adelia17@gmail.com',
                  style: app_theme.primaryTextStyle.copyWith(
                    color: app_theme.kBlackColor.withOpacity(0.6),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const EditProfileScreen(),
              ));
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: app_theme.kBlackColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward_ios,
                color: app_theme.kWhiteColor,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Section Title Widget
  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      child: Text(
        title,
        style: app_theme.blackTextStyle.copyWith(
          fontSize: 18,
          fontWeight: app_theme.bold,
        ),
      ),
    );
  }

  // Reusable list tile for settings
  Widget _buildSettingsTile({required String title, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: app_theme.primaryTextStyle.copyWith(
                color: app_theme.kPrimaryColor,
                fontSize: 16,
                fontWeight: app_theme.semiBold,
              ),
            ),
            Icon(Icons.chevron_right, color: app_theme.kPrimaryColor),
          ],
        ),
      ),
    );
  }
}

// CustomClipper for the wave effect
class WaveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height * 0.4);
    path.quadraticBezierTo(
        size.width / 4, size.height * 0.2, size.width / 2, size.height * 0.5);
    path.quadraticBezierTo(size.width - (size.width / 4), size.height * 0.8,
        size.width, size.height * 0.6);
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}