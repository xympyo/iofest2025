import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/daily_task_today.dart';
import '../shared/theme.dart' as app_theme;
import '../widgets/custom_bottom_nav_bar.dart';
import '../widgets/ai_analytics_card.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, dynamic>? _aiAnalyticsData;
  bool _aiAnalyticsLoading = false;
  String? _aiAnalyticsError;

  Future<void> _generateAiAnalytics() async {
    setState(() {
      _aiAnalyticsLoading = true;
      _aiAnalyticsError = null;
      _aiAnalyticsData = null;
    });
    try {
      final aiContext = await ApiService.fetchAiContext();
      if (aiContext == null) throw Exception('No context data');
      final String analyticsPrompt =
          '''You are TappyAI, an expert children's learning analytics assistant for parents. Your job is to analyze the provided data and return as many helpful, actionable insights as possible, based on what is available.

Rules:
1. Respond ONLY in valid JSON with this structure:
   {
     "role": "tappyai",
     "progress_summary": "<summary of the child's recent reading/activity progress, highlight improvements or trends>",
     "recommendation": "<personalized storybook or activity suggestion, with a brief reason>",
     "engagement_alert": "<alert if engagement has dropped or a positive streak is achieved, otherwise null>",
     "reading_streak": "<summary of current reading or activity streak, otherwise null>",
     "learning_style_inference": "<inferred learning style or preferences based on activity and reading data, otherwise null>",
     "parent_tip": "<short, actionable tip for the parent, otherwise null>"
   }
2. If a field is not applicable or there is not enough data, set its value to null.
3. Make your language clear, supportive, and parent-friendly.
4. Use only the data provided below—do not make up information.
5. Do not include any explanations or text outside the JSON.

Here is the child's data:
${jsonEncode(aiContext)}''';
      // Instead of sendToFireworksAI, call Fireworks directly for analytics and get the full response
      final apiKey =
          'fw_3ZKRcdUjGQN8ea8kyb8DMZzd'; // Use your actual key or refactor to get from ApiService
      final url =
          Uri.parse('https://api.fireworks.ai/inference/v1/chat/completions');
      final messages = [
        {"role": "user", "content": analyticsPrompt},
      ];
      final body = jsonEncode({
        "model": "accounts/fireworks/models/llama4-maverick-instruct-basic",
        "messages": messages,
        "max_tokens": 131072,
        "top_p": 1,
        "top_k": 40,
        "presence_penalty": 0,
        "frequency_penalty": 0,
        "temperature": 0.6,
      });
      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: body,
      );
      if (response.statusCode != 200)
        throw Exception('Fireworks error: ' + response.body);
      final aiResponse = response.body;

      Map<String, dynamic>? analyticsJson;
      try {
        print('AI Analytics RAW aiResponse: $aiResponse');
        // Try to parse as Fireworks full response (choices[0].message.content)
        final fireworksObj = json.decode(aiResponse);
        print(
            'AI Analytics parsed Fireworks object: ' + fireworksObj.toString());
        final content = fireworksObj['choices']?[0]?['message']?['content'];
        print('AI Analytics extracted content: $content');
        if (content is String) {
          analyticsJson = json.decode(content);
        } else {
          throw Exception('No analytics content found in Fireworks response.');
        }
      } catch (e) {
        print('AI Analytics JSON parsing error: $e');
        setState(() {
          _aiAnalyticsError = 'Parsing error: ' + e.toString();
          _aiAnalyticsLoading = false;
        });
        return;
      }
      setState(() {
        _aiAnalyticsData = analyticsJson;
        _aiAnalyticsLoading = false;
      });
    } catch (e) {
      setState(() {
        _aiAnalyticsError = 'Could not generate AI insights. Please try again.';
        _aiAnalyticsLoading = false;
      });
    }
  }

  Widget _buildAiAnalyticsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics, color: Color(0xFF5D5A88)),
            const SizedBox(width: 8),
            Text('[Beta] AI Analytics',
                style: app_theme.primaryTextStyle.copyWith(
                  fontWeight: app_theme.bold,
                  fontSize: 20,
                  color: Color(0xFF5D5A88),
                )),
          ],
        ),
        const SizedBox(height: 8),
        if (_aiAnalyticsData == null && !_aiAnalyticsLoading)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFFB7AFFF),
                foregroundColor: Color(0xFF5D5A88),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generate AI Insights'),
              onPressed: _generateAiAnalytics,
            ),
          ),
        if (_aiAnalyticsLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 32),
            child: Center(child: CircularProgressIndicator()),
          ),
        if (_aiAnalyticsError != null)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.redAccent),
            ),
            child: Row(
              children: [
                const Icon(Icons.error, color: Colors.redAccent),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(_aiAnalyticsError!,
                      style: app_theme.primaryTextStyle.copyWith(
                        color: Colors.redAccent,
                        fontWeight: app_theme.semiBold,
                      )),
                ),
              ],
            ),
          ),
        if (_aiAnalyticsData != null)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (_aiAnalyticsData!["progress_summary"] != null)
                AiAnalyticsCard(
                  title: 'Progress Summary & Highlights',
                  content: _aiAnalyticsData!["progress_summary"],
                  icon: Icons.rocket_launch_rounded,
                  color: Color(0xFFB7AFFF),
                ),
              if (_aiAnalyticsData!["recommendation"] != null)
                AiAnalyticsCard(
                  title: 'AI Personalized Recommendation',
                  content: _aiAnalyticsData!["recommendation"],
                  icon: Icons.tips_and_updates_rounded,
                  color: Color(0xFFB7AFFF),
                ),
              if (_aiAnalyticsData!["engagement_alert"] != null)
                AiAnalyticsCard(
                  title: 'Engagement Alert',
                  content: _aiAnalyticsData!["engagement_alert"],
                  icon: Icons.warning_amber_rounded,
                  color: Colors.deepOrangeAccent,
                  isAlert: true,
                ),
              if (_aiAnalyticsData!["reading_streak"] != null)
                AiAnalyticsCard(
                  title: 'Reading Streak',
                  content: _aiAnalyticsData!["reading_streak"],
                  icon: Icons.auto_graph_rounded,
                  color: Color(0xFFB7AFFF),
                ),
              if (_aiAnalyticsData!["learning_style_inference"] != null)
                AiAnalyticsCard(
                  title: 'Learning Style Inference',
                  content: _aiAnalyticsData!["learning_style_inference"],
                  icon: Icons.psychology_alt_rounded,
                  color: Color(0xFFB7AFFF),
                ),
              if (_aiAnalyticsData!["parent_tip"] != null)
                AiAnalyticsCard(
                  title: 'Parent Tip',
                  content: _aiAnalyticsData!["parent_tip"],
                  icon: Icons.lightbulb_rounded,
                  color: Color(0xFFB7AFFF),
                ),
            ],
          ),
      ],
    );
  }

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
                    const SizedBox(height: 24),
                    _buildAiAnalyticsSection(),
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
                child: SizedBox(
                  height: 120,
                  child: _buildSpentTimeCard(
                    icon: Icons.timer_outlined,
                    title: 'Reading Time',
                    value: data.readingTime,
                    percentage: data.readingTimeChange,
                    subLabel: 'vs yesterday',
                    percentageColor: app_theme.kGreenSafeColor,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 120,
                  child: _buildSpentTimeCard(
                    icon: Icons.visibility_outlined,
                    title: 'Words Count',
                    value: data.wordsRead.toString(),
                    percentage: data.wordsReadChange,
                    subLabel: 'words read',
                    percentageColor: app_theme.kGreenSafeColor,
                  ),
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
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: app_theme.blackTextStyle.copyWith(
              fontSize: 28,
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
      decoration: ShapeDecoration(
        color: stat.backgroundColor,
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment:
            MainAxisAlignment.spaceAround, // Adjusted mainAxisAlignment
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
