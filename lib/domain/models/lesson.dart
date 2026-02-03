class Lesson {
  final int id;
  final String title;
  final String summary;
  final String category;
  final int minutes;
  final int xp;
  final List<String> keyPoints;

  const Lesson({
    required this.id,
    required this.title,
    required this.summary,
    required this.category,
    required this.minutes,
    required this.xp,
    required this.keyPoints,
  });
}
