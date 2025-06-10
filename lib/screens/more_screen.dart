import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;
import '../widgets/custom_bottom_nav_bar.dart';

// Impor semua halaman tujuan Anda
import 'account_screen.dart';
import 'get_coin_screen.dart';
import 'premium_screen.dart';
import 'history_screen.dart';
import 'analytics_screen.dart';
// import 'home_screen.dart'; // Aktifkan jika sudah ada

class MoreScreen extends StatefulWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  State<MoreScreen> createState() => _MoreScreenState();
}

class _MoreScreenState extends State<MoreScreen> {
  int _currentIndex = 4;

  void _handleNavigation(int index) {
    if (index == _currentIndex) return;

    // Gunakan pushReplacement agar tidak menumpuk halaman di stack
    switch (index) {
      case 0: // Read
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ReadScreen()));
        break;
      case 1: // Cards
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const CardsScreen()));
        break;
      case 2: // Quick Activity
        // Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const QuickActivityScreen()));
        break;
      case 3: // Analytics
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => const AnalyticsScreen()));
        break;
      case 4: // More/Dashboard
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    // --- PERUBAHAN UTAMA DI SINI ---
    return Scaffold(
      // Buat background Scaffold transparan agar Stack bisa terlihat di belakang NavBar
      backgroundColor: app_theme.kWhiteColor,
      // Pindahkan NavBar ke dalam Stack
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Latar belakang atas
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Group 29.png',
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          // Latar belakang bawah
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              'assets/images/Group 1350.png',
              fit: BoxFit.fitWidth,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),

          // Konten Utama
          SafeArea(
            // Nonaktifkan SafeArea di bagian bawah agar konten bisa di-scroll sampai ke bawah
            bottom: false,
            child: SingleChildScrollView(
              child: Padding(
                // Tambahkan padding bawah seukuran tinggi navbar + margin
                padding: const EdgeInsets.only(bottom: 120.0),
                child: Column(
                  children: [
                    _buildHeader(context),
                    const SizedBox(height: 32),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: app_theme.defaultMargin),
                      child: Column(
                        children: [
                          _buildCoinBalanceCard(context),
                          const SizedBox(height: 32),
                          _buildMenuItems(context),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // NavBar sekarang berada di dalam Stack, di posisi paling atas secara visual
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                });
                _handleNavigation(index);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: app_theme.defaultMargin, vertical: 24),
      child: Center(
        child: Text(
          'More',
          style: app_theme.blackTextStyle.copyWith(
            fontSize: 24,
            fontWeight: app_theme.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCoinBalanceCard(BuildContext context) {
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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Image.asset('assets/images/coin.png', width: 32, height: 32),
              const SizedBox(width: 16),
              Text(
                '10',
                style: app_theme.blackTextStyle.copyWith(
                  fontSize: 22,
                  fontWeight: app_theme.bold,
                ),
              ),
            ],
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const GetCoinScreen()),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff404040),
              foregroundColor: app_theme.kWhiteColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            ),
            child: Text(
              'Get Coin',
              style: app_theme.whiteTextStyle
                  .copyWith(fontWeight: app_theme.semiBold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItems(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildMenuCard(
          context: context,
          iconPath: 'assets/images/account.png',
          label: 'Account',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AccountScreen()),
            );
          },
        ),
        _buildMenuCard(
          context: context,
          iconPath: 'assets/images/premium.png',
          label: 'Premium',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PremiumScreen()),
            );
          },
        ),
        _buildMenuCard(
          context: context,
          iconPath: 'assets/images/history.png',
          label: 'History',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const HistoryScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMenuCard(
      {required BuildContext context,
      required String iconPath,
      required String label,
      required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: app_theme.kPrimaryLightColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Image.asset(iconPath),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: app_theme.blackTextStyle.copyWith(
              fontWeight: app_theme.medium,
            ),
          )
        ],
      ),
    );
  }
}
