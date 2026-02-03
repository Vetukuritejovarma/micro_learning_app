import 'package:flutter/material.dart';

import '../../domain/models/quiz_question.dart';

class QuizCard extends StatelessWidget {
  final QuizQuestion question;
  final int? selectedIndex;
  final bool answered;
  final ValueChanged<int> onSelect;

  const QuizCard({
    super.key,
    required this.question,
    required this.selectedIndex,
    required this.answered,
    required this.onSelect,
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
          Text(
            question.prompt,
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 12),
          ...question.options.asMap().entries.map((entry) {
            final index = entry.key;
            final option = entry.value;
            final isCorrect = index == question.correctIndex;
            final isSelected = selectedIndex == index;
            final color = answered
                ? (isCorrect
                    ? const Color(0xFF7EF6D4)
                    : (isSelected ? const Color(0xFFFFB9A1) : const Color(0xFFF4F4F7)))
                : const Color(0xFFF4F4F7);

            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: answered ? null : () => onSelect(index),
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: answered && isCorrect ? const Color(0xFF38C7A5) : Colors.transparent,
                    ),
                  ),
                  child: Row(
                    children: [
                      Expanded(child: Text(option)),
                      if (answered && isCorrect)
                        const Icon(Icons.check_circle, color: Color(0xFF138D74))
                      else if (answered && isSelected)
                        const Icon(Icons.close_rounded, color: Color(0xFFE26B56))
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
