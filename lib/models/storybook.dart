class Storybook {
  final String id;
  final String title;
  final String author;
  final String imageUrl;
  final double rating;
  final String views;

  Storybook({
    required this.id,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.rating,
    required this.views,
  });
}

final List<Storybook> dummyStorybooks = [
  Storybook(
      id: '1',
      title: 'Kutukan Wanita Kuning Terhadap Pria OP',
      author: 'User 123',
      imageUrl: 'assets/images/placeholder_story1.png',
      rating: 4.8,
      views: '1.200'),
  Storybook(
      id: '2',
      title: 'Chrollo Durhaka Terhadap Wanita',
      author: 'User 456',
      imageUrl: 'assets/images/placeholder_story2.png',
      rating: 4.5,
      views: '1.2 jt'),
  Storybook(
      id: '3',
      title: 'Wanita Kuning Ternyata OP',
      author: 'User 789',
      imageUrl: 'assets/images/placeholder_story3.png',
      rating: 4.9,
      views: '980'),
  Storybook(
      id: '4',
      title: 'Ternyata Wanita Kuat Banget OP',
      author: 'User 101',
      imageUrl: 'assets/images/placeholder_story4.png',
      rating: 4.7,
      views: '1.200'),
  Storybook(
      id: '5',
      title: 'GG Chrollo WP',
      author: 'User 112',
      imageUrl: 'assets/images/placeholder_story5.png',
      rating: 4.8,
      views: '1.2 jt'),
];

final Storybook storyOfTheDay = Storybook(
  id: 'sotd',
  title: 'Lorem Ipsum Dolor Sit Amet',
  author: 'Lorem Ipsum Dolor Sit Amet',
  imageUrl: 'assets/images/storybook_of_the_day.png',
  rating: 4.8,
  views: '1.280',
);
