import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

// Data model untuk merepresentasikan setiap paket premium
class PremiumPackage {
  final String title;
  final String price;
  final List<String> features;
  final bool hasFreeTrial;
  final Color packageColor;
  final Color buttonColor;
  final bool isFeatured; // Untuk menandai paket "Star" yang tidak punya label "Premium"

  PremiumPackage({
    required this.title,
    required this.price,
    required this.features,
    this.hasFreeTrial = false,
    required this.packageColor,
    required this.buttonColor,
    this.isFeatured = false,
  });
}

class PremiumScreen extends StatelessWidget {
  const PremiumScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data tiruan untuk paket premium. Ini bisa diganti dengan data dari API.
    final List<PremiumPackage> packages = [
      PremiumPackage(
        title: 'Story package',
        price: 'Rp19.000 / bulan',
        features: [
          '1 Premium account',
          'Free access to dongeng berbayar (10 stories/month)',
          'Tanpa iklan',
          'Get 20 coins every month',
        ],
        hasFreeTrial: true,
        packageColor: const Color(0xffEFABA7), // Warna pink/salmon
        buttonColor: const Color(0xffEFABA7),
      ),
      PremiumPackage(
        title: 'Story package',
        price: 'Rp39.000 / bulan',
        features: [
          '1 Premium account',
          'Free access to dongeng berbayar (10 stories/month)',
          'Tanpa iklan',
          'Get 40 coins every month',
        ],
        hasFreeTrial: true,
        packageColor: app_theme.kPrimaryColor, // Warna ungu
        buttonColor: app_theme.kPrimaryColor,
      ),
      PremiumPackage(
        title: 'Star package',
        price: 'Rp59.000 / bulan',
        features: [
          '1 Premium account',
          'Free access to dongeng berbayar (10 stories/month)',
          'Tanpa iklan',
          'Get 60 coins every month',
        ],
        isFeatured: true, // Ini adalah paket "Star"
        packageColor: const Color(0xffEFABA7), // Warna pink/salmon
        buttonColor: const Color(0xffEFABA7),
      ),
    ];

    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar belakang
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Group 29.png',
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Group 1350.png',
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),

          // Konten Utama
          SafeArea(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 24.0),
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                ...packages.map((package) => Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
                  child: _buildPremiumCard(package),
                )).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: app_theme.kWhiteColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
              child: Image.asset('assets/images/back arrow.png', width: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Premium',
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 24,
              fontWeight: app_theme.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumCard(PremiumPackage package) {
    return Container(
      decoration: BoxDecoration(
        color: app_theme.kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.15),
            spreadRadius: 2,
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (!package.isFeatured)
                  Text(
                    'Premium',
                    style: app_theme.blackTextStyle.copyWith(
                      fontSize: 16,
                      fontWeight: app_theme.medium,
                    ),
                  ),
                Text(
                  package.title,
                  style: app_theme.secondaryTextStyle.copyWith(
                    fontSize: 22,
                    fontWeight: app_theme.bold,
                    color: package.packageColor,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  package.price,
                  style: app_theme.blackTextStyle.copyWith(fontSize: 14),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0),
                  child: Divider(height: 1),
                ),
                ...package.features.map((feature) => _buildFeatureRow(feature)).toList(),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: package.buttonColor,
                      foregroundColor: app_theme.kWhiteColor,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Get Premium',
                      style: app_theme.whiteTextStyle.copyWith(
                        fontSize: 16,
                        fontWeight: app_theme.bold,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          if (package.hasFreeTrial)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: package.packageColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Free Trial',
                  style: app_theme.whiteTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: app_theme.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '• ',
            style: app_theme.blackTextStyle.copyWith(fontSize: 14),
          ),
          Expanded(
            child: Text(
              text,
              style: app_theme.blackTextStyle.copyWith(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
