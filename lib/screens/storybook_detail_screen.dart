import 'package:flutter/material.dart';
import 'package:iofest/screens/storybook_content_screen.dart';
import '../models/storybook.dart';
import '../api_service.dart';
import '../shared/theme.dart' as app_theme;
import 'dart:ui'; // Diperlukan untuk ImageFilter

// Import your custom navigation bar
import '../widgets/custom_bottom_nav_bar.dart';

class StorybookDetailScreen extends StatefulWidget {
  final int storybookId;
  const StorybookDetailScreen({Key? key, required this.storybookId})
      : super(key: key);

  @override
  State<StorybookDetailScreen> createState() => _StorybookDetailScreenState();
}

class _StorybookDetailScreenState extends State<StorybookDetailScreen> {
  late Future<Storybook?> _storybookFuture;

  // **STEP 1: Add state for the currently selected navbar index**
  // Set to 2 to match the 'Storybook Clicked.png' UI
  int _currentIndex = 2;

  @override
  void initState() {
    super.initState();
    _storybookFuture = ApiService.fetchStorybookById(widget.storybookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // **STEP 2: Use extendBody to let the body draw behind the navbar**
      // This is crucial for the bottom wave image to be visible.
      extendBody: true,
      backgroundColor: app_theme.kWhiteColor,

      // **STEP 3: Add the CustomBottomNavBar**
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          // This makes the navbar interactive. You can add navigation
          // logic here to move to other screens if you want.
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: FutureBuilder<Storybook?>(
        future: _storybookFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('Failed to load storybook.'));
          }
          final storybook = snapshot.data!;

          // The Stack from our previous fix remains unchanged.
          // It works perfectly with the new navbar.
          return Stack(
            children: [
              // Background images and color
              Positioned(
                top: 0,
                right: 0,
                child: Image.asset(
                  'assets/images/Group 29.png',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Image.asset(
                  'assets/images/Group 28.png',
                  width: MediaQuery.of(context).size.width,
                ),
              ),
              // Scrollable content with bottom padding
              Positioned.fill(
                child: SafeArea(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                        left: 36,
                        right: 36,
                        top: 0,
                        bottom: 100), // enough bottom padding for nav bar
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          child: SafeArea(child: _buildHeader(context)),
                        ),
                        const SizedBox(
                            height: 32), // spacing for back button overlap
                        Text(
                          storybook.title,
                          textAlign: TextAlign.center,
                          style: app_theme.blackTextStyle.copyWith(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),
                        _buildCoverSection(storybook),
                        const SizedBox(height: 30 + 24),
                        _buildDescription(storybook.description),
                        Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: _buildAboutSection(storybook),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
              // Fixed back button (overlaps content)
            ],
          );
        },
      ),
    );
  }

  // --- BUILDER WIDGETS (No changes needed here) ---
  // ... (All your _build... methods remain the same as the previous step)
  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: app_theme.kPrimaryLightColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.asset('assets/images/back arrow.png',
                width: 24, height: 24),
          ),
        ),
      ],
    );
  }

  Widget _buildCoverSection(Storybook storybook) {
    return Center(
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                storybook.storybookProfile,
                height: 250,
                width: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: Colors.grey[200],
                  height: 250,
                  width: 200,
                  child: const Icon(Icons.broken_image, size: 48),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: app_theme.kWhiteColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          StorybookContentScreen(storybookId: storybook.id),
                    ),
                  );
                },
                child: Icon(Icons.play_arrow_rounded,
                    color: app_theme.kPrimaryColor, size: 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription(String description) {
    return Text(
      description,
      textAlign: TextAlign.center,
      style: app_theme.primaryTextStyle.copyWith(
        fontSize: 20,
        fontWeight: app_theme.bold,
        color: app_theme.kBlackColor.withOpacity(0.7),
        height: 1.5,
      ),
    );
  }

  Widget _buildAboutSection(Storybook storybook) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: ShapeDecoration(
        color: const Color(0xFFECECFA),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'About Storybook',
            style: app_theme.blackTextStyle
                .copyWith(fontSize: 18, fontWeight: app_theme.bold),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoPill(
                  icon: Icons.timer,
                  value: '${storybook.readTime}m',
                  label: 'People Read',
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInfoPill(
                  icon: Icons.remove_red_eye_outlined,
                  value: storybook.storybookWords.toString(),
                  label: 'Words Count',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoPill(
      {required IconData icon, required String value, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: ShapeDecoration(
        color: app_theme.kWhiteColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        shadows: [
          BoxShadow(
            color: Color(0x3F000000),
            blurRadius: 12,
            offset: Offset(0, 4),
            spreadRadius: 0,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: app_theme.kBlackColor, size: 16),
              const SizedBox(width: 8),
              Text(
                label,
                style: app_theme.blackTextStyle
                    .copyWith(fontSize: 12, fontWeight: app_theme.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: app_theme.blackTextStyle
                .copyWith(fontSize: 24, fontWeight: app_theme.black),
          ),
        ],
      ),
    );
  }
}
