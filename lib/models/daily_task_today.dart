class DailyTaskToday {
  final int? readingTime; // in minutes
  final int? wordsCount;
  final int cognitiveCount;
  final int sensoryCount;
  final int motorCount;
  final int emotionalCount;
  final List<dynamic> activities;

  DailyTaskToday({
    this.readingTime,
    this.wordsCount,
    required this.cognitiveCount,
    required this.sensoryCount,
    required this.motorCount,
    required this.emotionalCount,
    required this.activities,
  });

  factory DailyTaskToday.fromJson(Map<String, dynamic> json) {
    return DailyTaskToday(
      readingTime: json['reading_time'] == null ? null : int.tryParse(json['reading_time'].toString()),
      wordsCount: json['words_count'] == null ? null : int.tryParse(json['words_count'].toString()),
      cognitiveCount: json['cognitive_count'] == null ? 0 : json['cognitive_count'] as int,
      sensoryCount: json['sensory_count'] == null ? 0 : json['sensory_count'] as int,
      motorCount: json['motor_count'] == null ? 0 : json['motor_count'] as int,
      emotionalCount: json['emotional_count'] == null ? 0 : json['emotional_count'] as int,
      activities: json['daily_task_activities'] ?? [],
    );
  }
}