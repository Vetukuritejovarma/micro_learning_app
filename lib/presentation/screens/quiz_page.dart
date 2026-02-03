import 'package:flutter/material.dart';

import '../../data/lesson_data.dart';
import '../widgets/animated_card.dart';
import '../widgets/quiz_card.dart';

class QuizPage extends StatelessWidget {
  final Map<int, int> answers;
  final void Function(int id, int selectedIndex, int correctIndex) onAnswer;

  const QuizPage({
    super.key,
    required this.answers,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Text(
          'Quiz Arena',
          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'One tap to lock your answer. Gain bonus XP for correct picks.',
          style: theme.textTheme.titleMedium?.copyWith(color: const Color(0xFF6B6B75)),
        ),
        const SizedBox(height: 18),
        ...LessonData.questions.asMap().entries.map((entry) {
          final index = entry.key;
          final question = entry.value;
          final answer = answers[question.id];
          return AnimatedCard(
            delay: 90 * index,
            child: QuizCard(
              question: question,
              selectedIndex: answer,
              answered: answer != null,
              onSelect: (selected) {
                onAnswer(question.id, selected, question.correctIndex);
              },
            ),
          );
        }),
      ],
    );
  }
}
