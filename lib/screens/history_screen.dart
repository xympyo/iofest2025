import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

// Data model untuk cerita yang sudah selesai dibaca
class FinishedStory {
  final String imageUrl;
  final String title;
  final String review;
  final int rating;

  FinishedStory({
    required this.imageUrl,
    required this.title,
    required this.review,
    required this.rating,
  });
}

// Data model untuk cerita yang sedang dibaca
class ContinueStory {
  final String imageUrl;
  final String title;
  final int lastPage;

  ContinueStory({
    required this.imageUrl,
    required this.title,
    required this.lastPage,
  });
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Data tiruan (mock data) untuk ditampilkan di UI.
    // Nanti ini akan diganti dengan data dari API Anda.
    final List<FinishedStory> finishedStories = [
      FinishedStory(
        imageUrl: 'https://placehold.co/150x200/a9a9f5/FFFFFF?text=Hammy',
        title: 'Hammy the Hamster',
        review: '(review) Lorem ipsum dolor sit amet, conser adipiscing elit labore et dolore magna aliqua.',
        rating: 4,
      ),
       FinishedStory(
        imageUrl: 'https://placehold.co/150x200/a9a9f5/FFFFFF?text=Hammy',
        title: 'Hammy the Hamster',
        review: '(review) Lorem ipsum dolor sit amet, conser adipiscing elit labore et dolore magna aliqua.',
        rating: 5,
      ),
    ];

    final List<ContinueStory> continueStories = [
      ContinueStory(
        imageUrl: 'https://placehold.co/150x200/a9a9f5/FFFFFF?text=Hammy',
        title: 'Hammy the Hamster',
        lastPage: 3,
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
              padding: EdgeInsets.symmetric(vertical: 24.0),
              children: [
                _buildHeader(context),
                const SizedBox(height: 24),
                _buildSectionHeader('Finished Reading'),
                const SizedBox(height: 16),
                _buildFinishedList(finishedStories),
                const SizedBox(height: 32),
                _buildSectionHeader('Continue Reading'),
                const SizedBox(height: 16),
                _buildContinueList(continueStories),
                const SizedBox(height: 120), // Padding untuk bottom nav bar jika ada
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
                color: app_theme.kPrimaryLightColor.withOpacity(0.8),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
              child: Image.asset('assets/images/back arrow.png', width: 24),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'History',
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 24,
              fontWeight: app_theme.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 20,
              fontWeight: app_theme.bold,
            ),
          ),
          Text(
            'see all >',
            style: app_theme.primaryTextStyle.copyWith(
              fontSize: 14,
              fontWeight: app_theme.medium,
              color: app_theme.kPrimaryColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinishedList(List<FinishedStory> stories) {
    return ListView.separated(
      itemCount: stories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildFinishedCard(
          imageUrl: story.imageUrl,
          title: story.title,
          review: story.review,
          rating: story.rating,
        );
      },
    );
  }
  
  Widget _buildContinueList(List<ContinueStory> stories) {
     return ListView.separated(
      itemCount: stories.length,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final story = stories[index];
        return _buildContinueCard(
          imageUrl: story.imageUrl,
          title: story.title,
          lastPage: story.lastPage,
        );
      },
    );
  }

  Widget _buildFinishedCard({
    required String imageUrl,
    required String title,
    required String review,
    required int rating,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: app_theme.kWhiteColor,
        borderRadius: BorderRadius.circular(20),
        // --- PERUBAHAN 1: Memperbarui bayangan (shading) ---
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  // --- PERUBAHAN 2: Menambahkan loading indicator ---
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return Container(
                      width: 80,
                      height: 80,
                      color: Colors.grey[200],
                      child: Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          value: loadingProgress.expectedTotalBytes != null
                              ? loadingProgress.cumulativeBytesLoaded /
                                  loadingProgress.expectedTotalBytes!
                              : null,
                        ),
                      ),
                    );
                  },
                  // --- PERUBAHAN 3: Mengganti error placeholder ---
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[200],
                        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[400]),
                      ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: app_theme.blackTextStyle.copyWith(
                        fontSize: 18,
                        fontWeight: app_theme.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      review,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: app_theme.blackTextStyle.copyWith(fontSize: 13),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              color: app_theme.kPrimaryLightColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(5, (index) {
                return Icon(
                  Icons.star,
                  size: 32,
                  color: index < rating
                      ? app_theme.kPrimaryColor
                      : const Color(0xFFD9D7F1),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildContinueCard({
    required String imageUrl,
    required String title,
    required int lastPage,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: app_theme.kWhiteColor,
        borderRadius: BorderRadius.circular(20),
         // --- PERUBAHAN 1: Memperbarui bayangan (shading) ---
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              imageUrl,
              width: 80,
              height: 80,
              fit: BoxFit.cover,
               // --- PERUBAHAN 2: Menambahkan loading indicator ---
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[200],
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded /
                              loadingProgress.expectedTotalBytes!
                          : null,
                    ),
                  ),
                );
              },
              // --- PERUBAHAN 3: Mengganti error placeholder ---
              errorBuilder: (context, error, stackTrace) =>
                  Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[200],
                    child: Icon(Icons.image_not_supported_outlined, color: Colors.grey[400]),
                  ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: app_theme.blackTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: app_theme.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Last read in Page $lastPage',
                  style: app_theme.blackTextStyle.copyWith(fontSize: 14),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: app_theme.kPrimaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 24),
          )
        ],
      ),
    );
  }
}
