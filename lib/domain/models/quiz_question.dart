class QuizQuestion {
  final int id;
  final String prompt;
  final List<String> options;
  final int correctIndex;

  const QuizQuestion({
    required this.id,
    required this.prompt,
    required this.options,
    required this.correctIndex,
  });
}
