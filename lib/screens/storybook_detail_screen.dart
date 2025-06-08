import 'package:flutter/material.dart';
import '../models/storybook.dart';
import '../api_service.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../shared/theme.dart' as app_theme;

class StorybookDetailScreen extends StatefulWidget {
  final int storybookId;
  const StorybookDetailScreen({Key? key, required this.storybookId}) : super(key: key);

  @override
  State<StorybookDetailScreen> createState() => _StorybookDetailScreenState();
}

class _StorybookDetailScreenState extends State<StorybookDetailScreen> {
  late Future<Storybook?> _storybookFuture;
  int _currentNavIndex = 0;

  @override
  void initState() {
    super.initState();
    _storybookFuture = ApiService.fetchStorybookById(widget.storybookId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: SafeArea(
        child: FutureBuilder<Storybook?>(
          future: _storybookFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('Failed to load storybook.'));
            }
            final storybook = snapshot.data!;
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded),
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                          const Spacer(),
                        ],
                      ),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.network(
                          storybook.storybookProfile,
                          height: 180,
                          width: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            color: Colors.grey[200],
                            height: 180,
                            width: 180,
                            child: const Icon(Icons.broken_image, size: 48),
                          ),
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        storybook.title,
                        textAlign: TextAlign.center,
                        style: app_theme.blackTextStyle.copyWith(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        storybook.description,
                        textAlign: TextAlign.center,
                        style: app_theme.primaryTextStyle.copyWith(fontSize: 15, color: Colors.black87),
                      ),
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                        decoration: BoxDecoration(
                          color: app_theme.kPrimaryLightColor,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                const Icon(Icons.timer, color: Colors.deepPurple, size: 28),
                                const SizedBox(height: 4),
                                Text('${storybook.readTime} min', style: app_theme.primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('Read Time', style: app_theme.primaryTextStyle.copyWith(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                            Column(
                              children: [
                                const Icon(Icons.menu_book_rounded, color: Colors.deepPurple, size: 28),
                                const SizedBox(height: 4),
                                Text('${storybook.storybookWords}', style: app_theme.primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('Words', style: app_theme.primaryTextStyle.copyWith(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                            Column(
                              children: [
                                Icon(Icons.star, color: app_theme.kSecondaryColor, size: 28),
                                const SizedBox(height: 4),
                                Text('${storybook.averageRating.toStringAsFixed(1)}', style: app_theme.primaryTextStyle.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(height: 2),
                                Text('Rating', style: app_theme.primaryTextStyle.copyWith(fontSize: 12, color: Colors.black54)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
              ],
            );
          },
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentNavIndex,
        onTap: (idx) {
          setState(() {
            _currentNavIndex = idx;
          });
          // You can handle navigation here if needed
        },
      ),
    );
  }
}
