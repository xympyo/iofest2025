class ActivityCategory {
  final int id;
  final String category;
  final DateTime createdAt;
  final DateTime updatedAt;

  ActivityCategory({
    required this.id,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ActivityCategory.fromJson(Map<String, dynamic> json) {
    return ActivityCategory(
      id: json['id'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}

class Activity {
  final int id;
  final String title;
  final int activityCategoryId;
  final String description;
  final int durationMinutes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ActivityCategory activityCategory;

  Activity({
    required this.id,
    required this.title,
    required this.activityCategoryId,
    required this.description,
    required this.durationMinutes,
    required this.createdAt,
    required this.updatedAt,
    required this.activityCategory,
  });

  factory Activity.fromJson(Map<String, dynamic> json) {
    return Activity(
      id: json['id'],
      title: json['title'],
      activityCategoryId: json['activity_category_id'],
      description: json['description'],
      durationMinutes: json['duration_minutes'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      activityCategory: ActivityCategory.fromJson(json['activity_category']),
    );
  }
}
