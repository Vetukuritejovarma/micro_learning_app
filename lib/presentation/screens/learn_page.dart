import 'package:flutter/material.dart';

import '../../data/lesson_data.dart';
import '../widgets/animated_card.dart';
import '../widgets/lesson_card.dart';

class LearnPage extends StatelessWidget {
  final Set<int> completedLessons;
  final void Function(int id, int xp) onComplete;

  const LearnPage({
    super.key,
    required this.completedLessons,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Text(
          'Learn',
          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 6),
        Text(
          'Choose a lesson, earn XP, stack progress.',
          style: theme.textTheme.titleMedium?.copyWith(color: const Color(0xFF6B6B75)),
        ),
        const SizedBox(height: 18),
        ...LessonData.lessons.asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          return AnimatedCard(
            delay: 70 * index,
            child: LessonCard(
              lesson: lesson,
              completed: completedLessons.contains(lesson.id),
              onComplete: () => onComplete(lesson.id, lesson.xp),
            ),
          );
        }),
      ],
    );
  }
}
