import 'package:flutter/material.dart';
import '../shared/theme.dart' as app_theme;

class AiAnalyticsCard extends StatelessWidget {
  final String title;
  final String? content;
  final IconData icon;
  final Color color;
  final bool isAlert;

  const AiAnalyticsCard({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    this.color = const Color(0xFFB7AFFF),
    this.isAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    if (content == null || content!.trim().isEmpty) return SizedBox.shrink();
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withOpacity(isAlert ? 0.12 : 0.18),
        borderRadius: BorderRadius.circular(20),
        border: isAlert ? Border.all(color: Colors.redAccent, width: 2) : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: color.withOpacity(0.28),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.all(8),
            child: Icon(icon, color: color, size: 28),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: app_theme.primaryTextStyle.copyWith(
                    fontWeight: app_theme.bold,
                    fontSize: 16,
                    color: isAlert ? Colors.redAccent : color,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  content!,
                  style: app_theme.primaryTextStyle.copyWith(
                    fontWeight: app_theme.regular,
                    fontSize: 14,
                    color: app_theme.kBlackColor.withOpacity(0.85),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
