import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/daily_task_today.dart';
import '../shared/theme.dart' as app_theme;
import '../widgets/custom_bottom_nav_bar.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Future<DailyTaskToday?>? _futureDailyTask;
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    _futureDailyTask = ApiService.fetchDailyTaskToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      body: SafeArea(
        bottom: false,
        child: FutureBuilder<DailyTaskToday?>(
          future: _futureDailyTask,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: Text('Failed to load data: ${snapshot.error}'));
            }

            final realData = snapshot.data ??
                DailyTaskToday(
                  readingTime: 0,
                  wordsCount: 0,
                  cognitiveCount: 0,
                  sensoryCount: 0,
                  motorCount: 0,
                  emotionalCount: 0,
                  activities: [],
                );

            final uiData = _mapRealDataToUIData(realData);

            return SingleChildScrollView(
              child: Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: app_theme.defaultMargin),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildSpentTimeSection(uiData),
                    const SizedBox(height: 24),
                    Text(
                      'Your activity today!',
                      style: app_theme.blackTextStyle.copyWith(
                        fontSize: 22,
                        fontWeight: app_theme.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildTodayActivitySection(uiData),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  DashboardData _mapRealDataToUIData(DailyTaskToday realData) {
    String formattedReadingTime = '0m';
    if (realData.readingTime != null && realData.readingTime! > 0) {
      final h = realData.readingTime! ~/ 60;
      final m = realData.readingTime! % 60;
      if (h > 0) {
        formattedReadingTime = '${h}h ${m}m';
      } else {
        formattedReadingTime = '${m}m';
      }
    }

    return DashboardData(
      readingTime: formattedReadingTime,
      wordsRead: realData.wordsCount ?? 0,
      readingTimeChange: 0.0,
      wordsReadChange: 0.0,
      activityStats: [
        ActivityStat(
            categoryName: 'Cognitive',
            iconPath: 'assets/images/cognitive.png',
            activitiesDone: realData.cognitiveCount,
            timeSpent: '0m',
            backgroundColor: app_theme.kTriaryColor,
            textColor: const Color(0xffE59690)),
        ActivityStat(
            categoryName: 'Sensory',
            iconPath: 'assets/images/sensory.png',
            activitiesDone: realData.sensoryCount,
            timeSpent: '0m',
            backgroundColor: app_theme.kPrimaryColor,
            textColor: app_theme.kWhiteColor),
        ActivityStat(
            categoryName: 'Motor',
            iconPath: 'assets/images/motory.png',
            activitiesDone: realData.motorCount,
            timeSpent: '0m',
            backgroundColor: app_theme.kSecondaryColor,
            textColor: const Color(0xff9B443B)),
        ActivityStat(
            categoryName: 'Emotional',
            iconPath: 'assets/images/emotional.png',
            activitiesDone: realData.emotionalCount,
            timeSpent: '0m',
            backgroundColor: app_theme.kPrimaryLightColor,
            textColor: const Color(0xff8686C2)),
      ],
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: app_theme.kPrimaryLightColor,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: Center(
              child: Image.asset('assets/images/back arrow.png', width: 24),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          "You're doing great!",
          textAlign: TextAlign.center,
          style: app_theme.blackTextStyle.copyWith(
            fontSize: 28,
            fontWeight: app_theme.bold,
            height: 1.2,
          ),
        ),
      ],
    );
  }

  Widget _buildSpentTimeSection(DashboardData data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FD),
        borderRadius: BorderRadius.circular(app_theme.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'You spent',
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 22,
              fontWeight: app_theme.bold,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSpentTimeCard(
                  icon: Icons.timer_outlined,
                  title: 'Reading Time',
                  value: data.readingTime,
                  percentage: data.readingTimeChange,
                  subLabel: 'vs yesterday',
                  percentageColor: app_theme.kGreenSafeColor,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildSpentTimeCard(
                  icon: Icons.visibility_outlined,
                  title: 'Words Count',
                  value: data.wordsRead.toString(),
                  percentage: data.wordsReadChange,
                  subLabel: 'words read',
                  percentageColor: app_theme.kGreenSafeColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpentTimeCard({
    required IconData icon,
    required String title,
    required String value,
    required double percentage,
    required String subLabel,
    required Color percentageColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: app_theme.kWhiteColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: app_theme.kBlackColor),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: app_theme.blackTextStyle.copyWith(
                    fontWeight: app_theme.medium,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 26,
              fontWeight: app_theme.bold,
            ),
          ),
          if (percentage != 0) ...{
            const SizedBox(height: 4),
            Row(
              children: [
                Text(
                  '${percentage.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: percentageColor,
                    fontWeight: app_theme.semiBold,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  subLabel,
                  style: app_theme.blackTextStyle.copyWith(
                    fontSize: 12,
                    fontWeight: app_theme.regular,
                  ),
                ),
              ],
            ),
          },
        ],
      ),
    );
  }

  Widget _buildTodayActivitySection(DashboardData data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7FD),
        borderRadius: BorderRadius.circular(app_theme.defaultRadius),
      ),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: data.activityStats.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.92, // Slightly adjusted aspect ratio
        ),
        itemBuilder: (context, index) {
          final stat = data.activityStats.elementAt(index);
          return _buildActivityGridCard(stat: stat);
        },
      ),
    );
  }

  Widget _buildActivityGridCard({required ActivityStat stat}) {
    return Container(
      padding: const EdgeInsets.all(10), // Further reduced padding
      decoration: BoxDecoration(
        color: stat.backgroundColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround, // Adjusted mainAxisAlignment
        children: [
          const Spacer(flex: 1),
          Image.asset(
            stat.iconPath,
            width: 30,
            height: 30,
            errorBuilder: (context, error, stackTrace) =>
                const Icon(Icons.error),
          ),
          const SizedBox(height: 4),
          Text(
            stat.categoryName,
            textAlign: TextAlign.center,
            style: app_theme.whiteTextStyle.copyWith(
              color: stat.textColor.withOpacity(0.8),
              fontSize: 11,
              fontWeight: app_theme.medium,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            stat.activitiesDone.toString(),
            style: app_theme.whiteTextStyle.copyWith(
              color: stat.textColor,
              fontSize: 34, // Further reduced font size
              fontWeight: app_theme.bold,
            ),
          ),
          Text(
            'Done',
            style: app_theme.whiteTextStyle.copyWith(
              color: stat.textColor,
              fontSize: 20, // Further reduced font size
              fontWeight: app_theme.bold,
              height: 1.0,
            ),
          ),
          const Spacer(flex: 1),
          Align(
            alignment: Alignment.bottomLeft,
            child: Text(
              '${stat.timeSpent} Done',
              style: app_theme.whiteTextStyle.copyWith(
                color: stat.textColor.withOpacity(0.8),
                fontSize: 9,
                fontWeight: app_theme.medium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class DashboardData {
  final String readingTime;
  final double readingTimeChange;
  final int wordsRead;
  final double wordsReadChange;
  final List<ActivityStat> activityStats;

  DashboardData({
    required this.readingTime,
    required this.readingTimeChange,
    required this.wordsRead,
    required this.wordsReadChange,
    required this.activityStats,
  });
}

class ActivityStat {
  final String categoryName;
  final String iconPath;
  final int activitiesDone;
  final String timeSpent;
  final Color backgroundColor;
  final Color textColor;

  ActivityStat({
    required this.categoryName,
    required this.iconPath,
    required this.activitiesDone,
    required this.timeSpent,
    required this.backgroundColor,
    required this.textColor,
  });
}