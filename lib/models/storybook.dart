class Rating {
  final int userId;
  final double rating;
  final String comments;

  Rating({
    required this.userId,
    required this.rating,
    required this.comments,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      userId: json['user_id'] as int,
      rating: (json['rating'] as num).toDouble(),
      comments: json['comments'] ?? '',
    );
  }
}

class Storybook {
  final int id;
  final String title;
  final String description;
  final int storybookWords;
  final int readTime;
  final int readCount;
  final int pagesNumber;
  final bool isApproved;
  final List<String> genres;
  final int idLanguage;
  final String backgroundImage;
  final String storybookProfile;
  final DateTime? createdAt;
  final double averageRating;
  final int ratingsCount;
  final List<Rating> ratings;

  Storybook({
    required this.id,
    required this.title,
    required this.description,
    required this.storybookWords,
    required this.readTime,
    required this.readCount,
    required this.pagesNumber,
    required this.isApproved,
    required this.genres,
    required this.idLanguage,
    required this.backgroundImage,
    required this.storybookProfile,
    required this.createdAt,
    required this.averageRating,
    required this.ratingsCount,
    required this.ratings,
  });

  factory Storybook.fromJson(Map<String, dynamic> json) {
    return Storybook(
      id: json['id'] as int,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      storybookWords: json['storybook_words'] ?? 0,
      readTime: json['readTime'] ?? 0,
      readCount: json['readCount'] ?? 0,
      pagesNumber: json['pagesNumber'] ?? 0,
      isApproved: (json['isApproved'] == 1 || json['isApproved'] == true),
      genres: (json['genres'] as List?)?.map((g) => g.toString()).toList() ?? [],
      idLanguage: json['idLanguage'] ?? 0,
      backgroundImage: json['backgroundImage'] ?? '',
      storybookProfile: json['storybookProfile'] ?? '',
      createdAt: json['createdAt'] != null ? DateTime.tryParse(json['createdAt']) : null,
      averageRating: (json['average_rating'] as num?)?.toDouble() ?? 0.0,
      ratingsCount: json['ratings_count'] ?? 0,
      ratings: (json['ratings'] as List?)?.map((r) => Rating.fromJson(r)).toList() ?? [],
    );
  }
}
