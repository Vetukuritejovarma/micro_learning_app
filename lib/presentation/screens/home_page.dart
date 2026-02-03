import 'package:flutter/material.dart';

import '../../data/lesson_data.dart';
import '../widgets/animated_card.dart';
import '../widgets/lesson_card.dart';
import '../widgets/stat_chip.dart';

class HomePage extends StatelessWidget {
  final int xp;
  final int streak;
  final int dailyGoal;
  final Set<int> completedLessons;
  final void Function(int id, int xp) onComplete;

  const HomePage({
    super.key,
    required this.xp,
    required this.streak,
    required this.dailyGoal,
    required this.completedLessons,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remaining = dailyGoal - completedLessons.length;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Text(
          'BiteQuest',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: const Color(0xFF1B1B1F),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          'Micro-lessons that feel like a game',
          style: theme.textTheme.titleMedium?.copyWith(
            color: const Color(0xFF6B6B75),
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFF1B5EFF),
            borderRadius: BorderRadius.circular(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Today\'s Focus',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Build your money intuition',
                style: theme.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  StatChip(label: 'XP $xp', color: const Color(0xFFFFD24A)),
                  const SizedBox(width: 10),
                  StatChip(label: '$streak day streak', color: const Color(0xFF7EF6D4)),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              const Icon(Icons.flag_rounded, color: Color(0xFFFF8A3D)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  remaining > 0
                      ? '$remaining quick lessons to hit your daily goal.'
                      : 'Daily goal complete. Great momentum.',
                  style: theme.textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 22),
        Text(
          'Quick picks',
          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        ...LessonData.lessons.take(3).toList().asMap().entries.map((entry) {
          final index = entry.key;
          final lesson = entry.value;
          return AnimatedCard(
            delay: 80 * index,
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
