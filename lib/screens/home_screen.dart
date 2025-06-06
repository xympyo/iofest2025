import 'package:flutter/material.dart';

// Screen Imports
import 'account_screen.dart';
import 'quick_activity_screen.dart';

// Model Imports
import '../models/storybook.dart';

// Widget Imports
import '../widgets/storybook_of_the_day_card.dart';
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/section_title.dart';
import '../widgets/storybook_horizontal_list.dart';
import '../widgets/genre_selector.dart';
import '../widgets/favorite_genre_list.dart';
import '../widgets/activity_card.dart';

// Theme Import
import '../shared/theme.dart' as app_theme;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  // List of the main pages accessible from the bottom navigation bar.
  final List<Widget> _pages = [
    const HomePageContent(), // Index 0
    const QuickActivityScreen(), // <-- 2. REPLACE THE PLACEHOLDER FOR INDEX 1
    const PlaceholderPage(title: 'Create Page'), // Index 2
    const PlaceholderPage(title: 'Analytics Page'), // Index 3
    const PlaceholderPage(title: 'Dashboard Page'), // Index 4
  ];

  void _onNavItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: Stack(
        children: [
          // The body now shows the currently selected page from the _pages list
          _pages[_currentIndex],
          
          // The floating navigation bar is layered on top
          Align(
            alignment: Alignment.bottomCenter,
            child: CustomBottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onNavItemTapped,
            ),
          ),
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// The content of the home page (index 0)
// -----------------------------------------------------------------------------
class HomePageContent extends StatefulWidget {
  const HomePageContent({super.key});

  @override
  State<HomePageContent> createState() => _HomePageContentState();
}

class _HomePageContentState extends State<HomePageContent> {
  final String userName = "Moshe Dayan";
  final List<String> genres = ['Drama', 'Fantasi', 'Kerajaan', 'Komedi', 'Aksi'];
  final List<Map<String, dynamic>> favoriteGenres = [
    {'title': 'Romance', 'icon': Icons.favorite_border},
    {'title': 'Adventure', 'icon': Icons.explore_outlined},
    {'title': 'Fantasy', 'icon': Icons.auto_stories_outlined},
    {'title': 'Sci-Fi', 'icon': Icons.rocket_launch_outlined},
  ];
  int selectedGenreIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.only(top: 20),
        children: [
          _buildHeader(context),
          const SizedBox(height: 24),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
            child: StorybookOfTheDayCard(storybook: storyOfTheDay),
          ),
          const SizedBox(height: 24),
          const SectionTitle("Newest Storybook"),
          const SizedBox(height: 16),
          StorybookHorizontalList(dummyStorybooks.reversed.toList()),
          const SizedBox(height: 24),
          const SectionTitle("Most viewed Storybook"),
          const SizedBox(height: 16),
          StorybookHorizontalList(dummyStorybooks),
          const SizedBox(height: 24),
          const SectionTitle("Recommended Storybook"),
          const SizedBox(height: 16),
          StorybookHorizontalList(dummyStorybooks.skip(2).toList()),
          const SizedBox(height: 24),
          const SectionTitle("Best Storybook based of Genre"),
          const SizedBox(height: 16),
          GenreSelector(
            genres: genres,
            selectedIndex: selectedGenreIndex,
            onGenreSelected: (index) {
              setState(() {
                selectedGenreIndex = index;
              });
            },
          ),
          const SizedBox(height: 16),
          StorybookHorizontalList(dummyStorybooks.reversed.skip(1).toList()),
          const SizedBox(height: 24),
          _buildFavoriteGenreHeader(),
          const SizedBox(height: 16),
          FavoriteGenreList(favoriteGenres: favoriteGenres),
          const SizedBox(height: 24),
          const ActivityCard(),
          const SizedBox(height: 120),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Explore",
                    style: app_theme.blackTextStyle
                        .copyWith(fontSize: 30, fontWeight: app_theme.bold)),
                const SizedBox(height: 4),
                Text(userName,
                    style: app_theme.blackTextStyle
                        .copyWith(fontSize: 18, fontWeight: app_theme.semiBold)),
                const SizedBox(height: 8),
                Text(
                  "Hi, ready to read with your kid today?",
                  style: app_theme.primaryTextStyle.copyWith(
                      color: app_theme.kBlackColor.withOpacity(0.7),
                      fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const AccountScreen(),
              ));
            },
            child: CircleAvatar(
              radius: 28,
              backgroundColor: app_theme.kPrimaryLightColor,
              child: Icon(Icons.person,
                  color: app_theme.kPrimaryColor, size: 35),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFavoriteGenreHeader() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Favorite Genre',
            style: app_theme.blackTextStyle
                .copyWith(fontSize: 20, fontWeight: app_theme.bold),
          ),
          Icon(Icons.arrow_forward, color: app_theme.kBlackColor)
        ],
      ),
    );
  }
}

// -----------------------------------------------------------------------------
// A simple placeholder widget for your other pages.
// -----------------------------------------------------------------------------
class PlaceholderPage extends StatelessWidget {
  final String title;
  const PlaceholderPage({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: app_theme.blackTextStyle.copyWith(fontSize: 24, fontWeight: app_theme.bold),
      ),
    );
  }
}