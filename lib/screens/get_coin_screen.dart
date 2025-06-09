import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

// Data model sederhana untuk setiap paket koin
class CoinPackage {
  final String imagePath;
  final int amount;
  final int price;

  CoinPackage({
    required this.imagePath,
    required this.amount,
    required this.price,
  });
}

class GetCoinScreen extends StatelessWidget {
  const GetCoinScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CoinPackage> coinPackages = [
      CoinPackage(imagePath: 'assets/images/coin1.png', amount: 10, price: 15000),
      CoinPackage(imagePath: 'assets/images/coin2.png', amount: 20, price: 29000),
      CoinPackage(imagePath: 'assets/images/coin3.png', amount: 40, price: 55000),
      CoinPackage(imagePath: 'assets/images/coin4.png', amount: 65, price: 75000),
      CoinPackage(imagePath: 'assets/images/coin5.png', amount: 80, price: 89000),
      CoinPackage(imagePath: 'assets/images/coin6.png', amount: 100, price: 122000),
      CoinPackage(imagePath: 'assets/images/coin7.png', amount: 120, price: 140000),
      CoinPackage(imagePath: 'assets/images/coin8.png', amount: 150, price: 172000),
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

          // Konten utama
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    children: [
                      _buildHeader(context),
                      const SizedBox(height: 24),
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: app_theme.defaultMargin),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildCoinBalance(),
                            const SizedBox(height: 32),
                            Text(
                              'Coin Package',
                              style: app_theme.blackTextStyle.copyWith(
                                fontSize: 22,
                                fontWeight: app_theme.bold,
                              ),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Grid untuk paket koin
                SliverPadding(
                  padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
                  sliver: SliverGrid(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.8,
                    ),
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final package = coinPackages[index];
                        return _buildCoinPackageCard(
                          imagePath: package.imagePath,
                          amount: package.amount,
                          price: package.price,
                        );
                      },
                      childCount: coinPackages.length,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 120)), // Padding untuk navbar
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: app_theme.defaultMargin,
          right: app_theme.defaultMargin,
          top: 24),
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
            'Coin Shop',
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 24,
              fontWeight: app_theme.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinBalance() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: app_theme.kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Image.asset('assets/images/coin.png', width: 32, height: 32),
          const SizedBox(width: 16),
          Text(
            '10', // Saldo koin saat ini
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 22,
              fontWeight: app_theme.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCoinPackageCard({
    required String imagePath,
    required int amount,
    required int price,
  }) {
    final String formattedPrice = 'Rp${price.toString()}';

    return Container(
      decoration: BoxDecoration(
        color: app_theme.kWhiteColor,
        // --- PERUBAHAN 1: Mengubah corner radius menjadi 8 ---
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          // --- PERUBAHAN 2: Menyesuaikan bayangan agar lebih terlihat ---
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // --- PERUBAHAN 3: Menambahkan padding di atas gambar ---
          const SizedBox(height: 16),
          Image.asset(
            imagePath,
            width: 40,
            height: 40,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.broken_image, size: 40),
          ),
          const SizedBox(height: 8),
          Text(
            amount.toString(),
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 18,
              fontWeight: app_theme.bold,
            ),
          ),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: app_theme.kPrimaryLightColor,
              // Menyesuaikan radius bawah agar cocok dengan kartu utama
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
            ),
            child: Text(
              formattedPrice,
              textAlign: TextAlign.center,
              style: app_theme.blackTextStyle.copyWith(
                fontSize: 12,
                fontWeight: app_theme.semiBold,
                color: app_theme.kPrimaryColor,
              ),
            ),
          )
        ],
      ),
    );
  }
}
