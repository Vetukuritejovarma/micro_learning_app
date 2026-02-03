import 'package:flutter/material.dart';

import '../../domain/models/lesson.dart';

class LessonCard extends StatelessWidget {
  final Lesson lesson;
  final bool completed;
  final VoidCallback onComplete;

  const LessonCard({
    super.key,
    required this.lesson,
    required this.completed,
    required this.onComplete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE9F1FF),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  lesson.category.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: const Color(0xFF1B5EFF),
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.1,
                  ),
                ),
              ),
              const Spacer(),
              Text('${lesson.minutes} min', style: theme.textTheme.labelMedium),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            lesson.title,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(
            lesson.summary,
            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B6B75)),
          ),
          const SizedBox(height: 12),
          ...lesson.keyPoints.map((point) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.check_circle, size: 18, color: Color(0xFF7EF6D4)),
                    const SizedBox(width: 8),
                    Expanded(child: Text(point)),
                  ],
                ),
              )),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text('+${lesson.xp} XP', style: theme.textTheme.labelLarge),
              ),
              const Spacer(),
              FilledButton(
                onPressed: completed ? null : onComplete,
                style: FilledButton.styleFrom(
                  backgroundColor: completed ? const Color(0xFFB8B8C4) : const Color(0xFF1B5EFF),
                ),
                child: Text(completed ? 'Completed' : 'Complete'),
              )
            ],
          )
        ],
      ),
    );
  }
}
