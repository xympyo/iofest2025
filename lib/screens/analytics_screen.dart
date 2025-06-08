import 'package:flutter/material.dart';
import '../api_service.dart';
import '../models/daily_task_today.dart';
import '../shared/theme.dart' as app_theme;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Future<DailyTaskToday?>? _future;

  @override
  void initState() {
    super.initState();
    _future = ApiService.fetchDailyTaskToday();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_theme.kWhiteColor,
      body: SafeArea(
        child: FutureBuilder<DailyTaskToday?>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return const Center(child: Text('Failed to load analytics data'));
            }
            final data = snapshot.data ?? DailyTaskToday(
              readingTime: 0,
              wordsCount: 0,
              cognitiveCount: 0,
              sensoryCount: 0,
              motorCount: 0,
              emotionalCount: 0,
              activities: [],
            );
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: app_theme.defaultMargin, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded),
                          onPressed: () => Navigator.of(context).pop(),
                          color: app_theme.kBlackColor,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "You're doing\ngreat!",
                          style: app_theme.blackTextStyle.copyWith(
                            fontSize: 22,
                            fontWeight: app_theme.bold,
                          ),
                        ),
                        const SizedBox(height: 24),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: app_theme.kPrimaryLightColor,
                            borderRadius:
                                BorderRadius.circular(app_theme.defaultRadius),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    app_theme.kPrimaryColor.withOpacity(0.06),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'You spent',
                                style: app_theme.primaryTextStyle.copyWith(
                                  fontWeight: app_theme.bold,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  _AnalyticsStatCard(
                                    title: 'Reading Time',
                                    value: _formatReadingTime(data.readingTime),
                                    subtitle: '',
                                    icon: Icons.schedule,
                                    valueColor: Colors.black,
                                    delta: null,
                                  ),
                                  const SizedBox(width: 16),
                                  _AnalyticsStatCard(
                                    title: 'Words Count',
                                    value: data.wordsCount?.toString() ?? '0',
                                    subtitle: 'words read',
                                    icon: Icons.remove_red_eye_outlined,
                                    valueColor: Colors.black,
                                    delta: null,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Your activity today!',
                          style: app_theme.blackTextStyle.copyWith(
                            fontSize: 20,
                            fontWeight: app_theme.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        _ActivityBento(
                          cognitive: data.cognitiveCount,
                          sensory: data.sensoryCount,
                          motor: data.motorCount,
                          emotional: data.emotionalCount,
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'Activities Completed',
                          style: app_theme.primaryTextStyle.copyWith(
                            fontWeight: app_theme.bold,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, idx) {
                      final act = data.activities[idx];
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: app_theme.defaultMargin, vertical: 8),
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.circular(app_theme.defaultRadius),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    app_theme.kPrimaryColor.withOpacity(0.08),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              )
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                act['activity']?['title'] ?? '-',
                                style: app_theme.primaryTextStyle.copyWith(
                                  fontWeight: app_theme.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                act['activity']?['description'] ?? '',
                                style: app_theme.teksTextStyle
                                    .copyWith(fontSize: 13),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.check_circle_rounded,
                                      color: app_theme.kPrimaryColor, size: 18),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Done at: ' + (act['completed_at'] ?? '-'),
                                    style: app_theme.primaryTextStyle
                                        .copyWith(fontSize: 12),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: data.activities.length,
                  ),
                ),
                SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            );
          },
        ),
      ),
    );
  }

  String _formatReadingTime(int? minutes) {
    if (minutes == null) return '0m';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h > 0) {
      return '${h}h ${m}m';
    }
    return '${m}m';
  }
}

class _AnalyticsStatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color valueColor;
  final double? delta;

  const _AnalyticsStatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.valueColor,
    this.delta,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: app_theme.kPrimaryColor, size: 20),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: app_theme.primaryTextStyle.copyWith(
                    fontWeight: app_theme.semiBold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: app_theme.primaryTextStyle.copyWith(
                fontWeight: app_theme.bold,
                fontSize: 22,
                color: valueColor,
              ),
            ),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: app_theme.teksTextStyle.copyWith(fontSize: 12),
              ),
            if (delta != null)
              Text(
                (delta! > 0 ? '+' : '') +
                    (delta! * 100).toStringAsFixed(1) +
                    '%',
                style: TextStyle(
                  color: delta! > 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ActivityBento extends StatelessWidget {
  final int cognitive;
  final int sensory;
  final int motor;
  final int emotional;
  const _ActivityBento({
    required this.cognitive,
    required this.sensory,
    required this.motor,
    required this.emotional,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: app_theme.kPrimaryLightColor,
        borderRadius: BorderRadius.circular(app_theme.defaultRadius * 1.5),
        boxShadow: [
          BoxShadow(
            color: app_theme.kPrimaryColor.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: GridView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.3,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        children: [
          _BentoCard(
            label: 'Cognitive',
            count: cognitive,
            color: const Color(0xFFFCEEEC),
            icon: Icons.psychology_alt_outlined,
            minutes: cognitive > 0 ? '12m Done' : '0m Done',
          ),
          _BentoCard(
            label: 'Sensory',
            count: sensory,
            color: const Color(0xFFEAEAFF),
            icon: Icons.pan_tool_alt_outlined,
            minutes: sensory > 0 ? '16m Done' : '0m Done',
          ),
          _BentoCard(
            label: 'Motor',
            count: motor,
            color: const Color(0xFFFCEEEC),
            icon: Icons.access_alarm,
            minutes: motor > 0 ? '4m Done' : '0m Done',
          ),
          _BentoCard(
            label: 'Emotional',
            count: emotional,
            color: const Color(0xFFEAEAFF),
            icon: Icons.favorite_border,
            minutes: emotional > 0 ? '8m Done' : '0m Done',
          ),
        ],
      ),
    );
  }
}

class _BentoCard extends StatelessWidget {
  final String label;
  final int count;
  final Color color;
  final IconData icon;
  final String minutes;
  const _BentoCard({
    required this.label,
    required this.count,
    required this.color,
    required this.icon,
    required this.minutes,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: app_theme.kPrimaryColor, size: 28),
          const SizedBox(height: 6),
          Text(
            '$count',
            style: app_theme.primaryTextStyle.copyWith(
              fontWeight: app_theme.bold,
              fontSize: 22,
            ),
          ),
          Text(
            'Done',
            style: app_theme.primaryTextStyle.copyWith(
              fontWeight: app_theme.semiBold,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            minutes,
            style: app_theme.teksTextStyle.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
