import 'package:flutter/material.dart';
import '../widgets/activity_info_card.dart';
import '../models/activity.dart';
import '../api_service.dart';
import '../shared/theme.dart' as app_theme;

class QuickActivityScreen extends StatefulWidget {
  const QuickActivityScreen({super.key});

  @override
  State<QuickActivityScreen> createState() => _QuickActivityScreenState();
}

class _QuickActivityScreenState extends State<QuickActivityScreen>
    with SingleTickerProviderStateMixin {
  bool isCardChosen = false;
  List<Activity> _activities = [];
  List<Activity> _displayed = []; // 3 activities: left, middle, right
  bool _isLoading = true;
  bool _isShuffling = false;
  Activity? _chosen;
  late AnimationController _controller;
  late Animation<double> _shuffleAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _shuffleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _fetchActivities();
  }

  Future<void> _fetchActivities() async {
    setState(() {
      _isLoading = true;
    });
    final acts = await ApiService.fetchAllActivities();
    if (acts.isNotEmpty) {
      acts.shuffle();
      setState(() {
        _activities = acts;
        _displayed = acts.take(3).toList();
        _isLoading = false;
      });
    } else {
      // fallback: try random API
      final random = await ApiService.fetchRandomActivity();
      setState(() {
        _activities = random != null ? [random] : [];
        _displayed = random != null ? [random, random, random] : [];
        _isLoading = false;
      });
    }
  }

  void _startShuffle() async {
    if (_isShuffling || _isLoading) return;
    setState(() {
      _isShuffling = true;
      isCardChosen = false;
    });
    int shuffleCount = 0;
    final rand = _activities.toList()..shuffle();
    List<Activity> pool = rand;
    if (pool.length < 3) pool.addAll(pool); // Ensure at least 3
    _displayed = pool.take(3).toList();
    _controller.reset();

    // Animate cards to right, bring new to left, repeat
    for (int i = 0; i < 6; i++) {
      await Future.delayed(const Duration(milliseconds: 350));
      setState(() {
        // rotate: left->middle, middle->right, new->left
        _displayed = [
          pool[(i + 3) % pool.length],
          _displayed[0],
          _displayed[1],
        ];
        shuffleCount++;
      });
      _controller.forward(from: 0);
    }
    // After 3 seconds, pick random (API preferred)
    final apiResult = await ApiService.fetchRandomActivity();
    Activity chosen;
    if (apiResult != null) {
      chosen = apiResult;
    } else {
      chosen = (_activities..shuffle()).first;
    }
    setState(() {
      _chosen = chosen;
      _displayed = [chosen, chosen, chosen];
      isCardChosen = true;
      _isShuffling = false;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Top Title
              Text(
                "Let's choose what\nactivity we can do today!",
                textAlign: TextAlign.center,
                style: app_theme.blackTextStyle.copyWith(
                  fontSize: 28,
                  fontWeight: app_theme.bold,
                ),
              ),
              // Animated Activity Cards
              if (_isLoading)
                const SizedBox(
                  height: 400,
                  child: Center(child: CircularProgressIndicator()),
                )
              else
                SizedBox(
                  height: 400,
                  child: Center(
                    child: SizedBox(
                      width: 320, // Only show the center area, cards overflow
                      height: 400,
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          // Left card (partially offscreen to the left)
                          if (_displayed.length > 0)
                            Positioned(
                              left: -100,
                              top: 40,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 250),
                                opacity: _isShuffling || !isCardChosen ? 1 : 0.5,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: ActivityInfoCard(
                                    category: _displayed[0].activityCategory.category,
                                    iconPath: _getIconForCategory(_displayed[0].activityCategory.category),
                                    title: _displayed[0].title,
                                    description: _displayed[0].description,
                                    backgroundColor: app_theme.kTriaryColor,
                                    width: 200,
                                    height: 320,
                                    isLoading: false,
                                  ),
                                ),
                              ),
                            ),
                          // Middle card (centered, on top)
                          if (_displayed.length > 1)
                            Positioned(
                              left: 20,
                              top: 0,
                              child: AnimatedScale(
                                duration: const Duration(milliseconds: 300),
                                scale: 1.0,
                                child: ActivityInfoCard(
                                  category: _displayed[1].activityCategory.category,
                                  iconPath: _getIconForCategory(_displayed[1].activityCategory.category),
                                  title: _displayed[1].title,
                                  description: _displayed[1].description,
                                  backgroundColor: app_theme.kPrimaryColor,
                                  width: 280,
                                  height: 400,
                                  isLoading: false,
                                ),
                              ),
                            ),
                          // Right card (partially offscreen to the right)
                          if (_displayed.length > 2)
                            Positioned(
                              right: -100,
                              top: 40,
                              child: AnimatedOpacity(
                                duration: const Duration(milliseconds: 250),
                                opacity: _isShuffling || !isCardChosen ? 1 : 0.5,
                                child: Transform.scale(
                                  scale: 0.8,
                                  child: ActivityInfoCard(
                                    category: _displayed[2].activityCategory.category,
                                    iconPath: _getIconForCategory(_displayed[2].activityCategory.category),
                                    title: _displayed[2].title,
                                    description: _displayed[2].description,
                                    backgroundColor: app_theme.kTriaryColor.withOpacity(0.8),
                                    width: 200,
                                    height: 320,
                                    isLoading: false,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              const SizedBox(
                height: 24,
              ),
              _buildBottomButton(),
            ],
          ),
        ),
      ),
    );
  }

  String _getIconForCategory(String category) {
    // Map categories to asset paths, update as needed
    switch (category.toLowerCase()) {
      case 'cognitive':
        return 'assets/images/brain.png';
      case 'sensory':
        return 'assets/images/sensory.png';
      case 'motory':
        return 'assets/images/motory.png';
      case 'emotional':
        return 'assets/images/emotional.png';
      default:
        return 'assets/images/brain.png';
    }
  }

  // Helper to build the button at the bottom
  Widget _buildBottomButton() {
    return GestureDetector(
      onTap: (_isLoading || _isShuffling)
          ? null
          : () {
              if (!isCardChosen) {
                _startShuffle();
              } else {
                // You can handle "Finish" action here
                Navigator.of(context).pop(_chosen);
              }
            },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60,
        width: isCardChosen ? 200 : 60, // Animate width change
        decoration: BoxDecoration(
          color: isCardChosen ? app_theme.kBlackColor : app_theme.kPrimaryColor,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Center(
          child: _isShuffling
              ? const SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                      strokeWidth: 3, color: Colors.white),
                )
              : isCardChosen
                  ? Text('Finish',
                      style: app_theme.whiteTextStyle.copyWith(fontSize: 16))
                  : Icon(Icons.sync, color: app_theme.kWhiteColor, size: 30),
        ),
      ),
    );
  }
}
