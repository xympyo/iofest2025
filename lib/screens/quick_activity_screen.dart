import 'package:flutter/material.dart';
import 'package:iofest/widgets/activity_feedback_sheet.dart';
import 'dart:math';
import '../widgets/activity_info_card.dart';
import '../models/activity.dart';
import '../models/activity_card_design.dart';
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
  List<Activity> _displayed = [];
  bool _isLoading = true;
  bool _isShuffling = false;
  Activity? _chosen;
  late AnimationController _controller;
  late Animation<double> _shuffleAnim;

  final Map<String, ActivityCardDesign> _designMap = {};

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _shuffleAnim =
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
    _fetchActivities();
  }

  // --- Card Design Selection Logic (No changes) ---

  ActivityCardDesign _getDesignForActivity(Activity activity) {
    final String activityId = activity.id.toString();
    if (_designMap.containsKey(activityId)) {
      return _designMap[activityId]!;
    }
    final design =
        _getRandomDesignForCategory(activity.activityCategory.category);
    _designMap[activityId] = design;
    return design;
  }

  ActivityCardDesign _getRandomDesignForCategory(String category) {
    final rand = Random();
    final variant = rand.nextInt(2);

    switch (category.toLowerCase()) {
      case 'cognitive':
        return variant == 0
            ? ActivityCardDesign(
                backgroundColor: app_theme.kTriaryColor,
                categoryIcon: 'assets/images/cognitive.png',
                backgroundShape: 'assets/images/Intersect.png')
            : ActivityCardDesign(
                backgroundColor: app_theme.kSecondaryColor,
                categoryIcon: 'assets/images/cognitive2.png',
                backgroundShape: 'assets/images/Intersect2.png');
      case 'sensory':
        return variant == 0
            ? ActivityCardDesign(
                backgroundColor: app_theme.kPrimaryColor,
                categoryIcon: 'assets/images/sensory.png',
                backgroundShape: 'assets/images/cloud.png')
            : ActivityCardDesign(
                backgroundColor: app_theme.kPrimaryLightColor,
                categoryIcon: 'assets/images/sensory2.png',
                backgroundShape: 'assets/images/cloud2.png');
      case 'motory':
        return variant == 0
            ? ActivityCardDesign(
                backgroundColor: app_theme.kSecondaryColor,
                categoryIcon: 'assets/images/motory.png',
                backgroundShape: 'assets/images/motor.png')
            : ActivityCardDesign(
                backgroundColor: app_theme.kTriaryColor,
                categoryIcon: 'assets/images/motory2.png',
                backgroundShape: 'assets/images/motor2.png');
      case 'emotional':
        return variant == 0
            ? ActivityCardDesign(
                backgroundColor: app_theme.kPrimaryLightColor,
                categoryIcon: 'assets/images/emotional.png',
                backgroundShape: 'assets/images/wave.png')
            : ActivityCardDesign(
                backgroundColor: app_theme.kPrimaryColor,
                categoryIcon: 'assets/images/emotional2.png',
                backgroundShape: 'assets/images/wave2.png');
      default:
        return ActivityCardDesign(
            backgroundColor: app_theme.kTriaryColor,
            categoryIcon: 'assets/images/cognitive.png',
            backgroundShape: 'assets/images/Intersect.png');
    }
  }

  // --- Data Fetching (No changes) ---

  Future<void> _fetchActivities() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    final acts = await ApiService.fetchAllActivities();
    if (mounted && acts.isNotEmpty) {
      acts.shuffle();
      setState(() {
        _activities = acts;
        _displayed = acts.take(3).toList();
        _isLoading = false;
      });
    } else if (mounted) {
      final random = await ApiService.fetchRandomActivity();
      setState(() {
        _activities = random != null ? [random] : [];
        _displayed = random != null ? [random, random, random] : [];
        _isLoading = false;
      });
    }
  }

  // --- Shuffle Logic (No changes) ---
  void _startShuffle() async {
    if (_isShuffling || _isLoading || _activities.isEmpty) return;
    if (_activities.length < 3) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Not enough activities to shuffle."))
        );
        return;
    }

    setState(() {
      _isShuffling = true;
      isCardChosen = false;
    });

    final rand = _activities.toList()..shuffle();
    List<Activity> pool = rand;
    _displayed = pool.take(3).toList();
    _controller.reset();

    for (int i = 0; i < 6; i++) {
      if (!mounted) return;
      await Future.delayed(const Duration(milliseconds: 350));
      setState(() {
        _displayed = [
          pool[(i + 3) % pool.length],
          _displayed[0],
          _displayed[1],
        ];
      });
      _controller.forward(from: 0);
    }

    if (!mounted) return;
    final apiResult = await ApiService.fetchRandomActivity();
    final chosenActivity = apiResult ?? (_activities..shuffle()).first;

    final otherActivities = _activities.where((act) => act.id != chosenActivity.id).toList()..shuffle();

    final finalDisplay = [
      otherActivities[0],
      chosenActivity,
      otherActivities[1],
    ];

    setState(() {
      _chosen = chosenActivity;
      _displayed = finalDisplay;
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
      body: Stack(
        children: [
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

          SafeArea(
            child: Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
              // **FIX: Replaced spaceEvenly with Spacers and SizedBoxes for better control**
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2), // Pushes the title down from the top a bit
                  Text(
                    "Let's choose what\nactivity we can do today!",
                    textAlign: TextAlign.center,
                    style: app_theme.blackTextStyle
                        .copyWith(fontSize: 28, fontWeight: app_theme.bold),
                  ),
                  const Spacer(flex: 1), // Adds space between title and cards
                  if (_isLoading)
                    const Expanded(
                        flex: 15, // Give it a flex value to occupy space
                        child: Center(child: CircularProgressIndicator()))
                  else
                    SizedBox(
                      height: 400,
                      child: Center(
                        child: SizedBox(
                          width: 320,
                          height: 400,
                          child: Stack(
                            clipBehavior: Clip.none,
                            children: [
                              if (_displayed.isNotEmpty)
                                _buildAnimatedCard(
                                    activity: _displayed[0], position: -1),
                              if (_displayed.length > 2)
                                _buildAnimatedCard(
                                    activity: _displayed[2], position: 1),
                              if (_displayed.length > 1)
                                _buildAnimatedCard(
                                    activity: _displayed[1],
                                    position: 0,
                                    isCenter: true),
                            ],
                          ),
                        ),
                      ),
                    ),
                  const Spacer(flex: 4), // Pushes the button up from the bottom
                  _buildBottomButton(),
                  const SizedBox(height: 120), // **FIX: Added 16px bottom padding**
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnimatedCard(
      {required Activity activity,
      required int position,
      bool isCenter = false}) {
    final design = _getDesignForActivity(activity);
    double left = (320 - 280) / 2; // Center position
    if (position == -1) left = -100;
    if (position == 1) left = 160;

    return Positioned(
      top: isCenter ? 40 : 40,
      left: left,
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 250),
        opacity: _isShuffling || !isCardChosen || isCenter ? 1.0 : 0.5,
        child: Transform.scale(
          scale: isCenter ? 1.0 : 0.8,
          child: ActivityInfoCard(
            category: activity.activityCategory.category,
            title: activity.title,
            description: activity.description,
            backgroundColor: design.backgroundColor,
            iconPath: design.categoryIcon,
            backgroundShapePath: design.backgroundShape,
            showClose: isCenter && isCardChosen,
            onClose: () {
              setState(() {
                isCardChosen = false;
                _chosen = null;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBottomButton() {
  if (isCardChosen) {
    // **FIX: Removed the explicit Padding widget from here**
    return GestureDetector(
      onTap: () {
        final activityId = _chosen?.id;
        if (activityId == null) return;
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => DraggableScrollableSheet(
            initialChildSize: 0.7,
            builder: (_, controller) => Material(
              borderRadius: BorderRadius.circular(24),
              color: Colors.white,
              child: ActivityFeedbackSheet(
                onSend: ({
                  required int understanding,
                  required int participation,
                  required String notes,
                }) async {
                  await ApiService.completeDailyTask(
                    activityId,
                    understanding: understanding,
                    participation: participation,
                    notes: notes,
                  );
                  if (!mounted) return;
                  Navigator.of(context).pop();
                  setState(() {
                    isCardChosen = false;
                    _chosen = null;
                  });
                },
                onClose: () {
                  Navigator.of(context).pop();
                  setState(() {
                    isCardChosen = false;
                    _chosen = null;
                  });
                },
              ),
            ),
          ),
        );
      },
      child: Container(
        width: 200,
        height: 60,
        decoration: BoxDecoration(
          color: app_theme.kBlackColor,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: app_theme.kBlackColor.withOpacity(0.25),
              blurRadius: 10,
              offset: const Offset(0, 5),
            )
          ],
        ),
        child: Center(
          child: Text('Finish',
              style: app_theme.whiteTextStyle.copyWith(fontSize: 16)),
        ),
      ),
    );
  } else {
    // **FIX: Removed the explicit Padding widget from here**
    return GestureDetector(
      onTap: _isLoading || _isShuffling ? null : _startShuffle,
      child: Container(
        width: 75,
        height: 75,
        decoration: BoxDecoration(
          color: app_theme.kWhiteColor,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: app_theme.kBlackColor.withOpacity(0.1),
              blurRadius: 15,
              spreadRadius: 5,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: _isShuffling
            ? CircularProgressIndicator(color: app_theme.kPrimaryColor)
            : Center(
                child: Image.asset('assets/images/randomize.png',
                    width: 40,
                    height: 40,
                    color: app_theme.kPrimaryColor),
              ),
      ),
    );
  }
  }
}