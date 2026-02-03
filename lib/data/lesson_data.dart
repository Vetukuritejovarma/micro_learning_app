import '../domain/models/lesson.dart';
import '../domain/models/quiz_question.dart';

class LessonData {
  static const lessons = [
    Lesson(
      id: 1,
      title: '50/30/20 rule in 90 seconds',
      summary: 'A fast budgeting system that prevents decision fatigue.',
      category: 'Money',
      minutes: 2,
      xp: 18,
      keyPoints: [
        '50% needs, 30% wants, 20% saving or debt.',
        'Adjust the ratios, but keep the split visible.',
        'Automate the 20% to protect it.'
      ],
    ),
    Lesson(
      id: 2,
      title: 'Stop doom scrolling with a 2-minute reset',
      summary: 'Reset your nervous system before you re-open your feed.',
      category: 'Mind',
      minutes: 3,
      xp: 16,
      keyPoints: [
        '4-7-8 breathing lowers stress fast.',
        'Name 5 things you can see to ground yourself.',
        'Put your phone out of reach for 90 seconds.'
      ],
    ),
    Lesson(
      id: 3,
      title: 'Micro habits that stick',
      summary: 'Reduce the activation energy so habits feel easy.',
      category: 'Growth',
      minutes: 3,
      xp: 14,
      keyPoints: [
        'Shrink the habit to a 2-minute version.',
        'Attach it to an existing routine.',
        'Track streaks, not perfection.'
      ],
    ),
    Lesson(
      id: 4,
      title: 'Eco wins: energy in your home',
      summary: 'Small changes that cut bills and emissions.',
      category: 'Planet',
      minutes: 4,
      xp: 20,
      keyPoints: [
        'Switch to LED bulbs, then forget about them.',
        'Wash with cold water when possible.',
        'Seal drafts around doors and windows.'
      ],
    ),
    Lesson(
      id: 5,
      title: 'Social confidence, the 3-2-1 approach',
      summary: 'A simple script for starting conversations.',
      category: 'People',
      minutes: 3,
      xp: 16,
      keyPoints: [
        '3 observations, 2 questions, 1 personal share.',
        'Use curiosity as the anchor.',
        'Leave on a high note.'
      ],
    ),
  ];

  static const questions = [
    QuizQuestion(
      id: 10,
      prompt: 'Which split is the 50/30/20 rule?',
      options: [
        'Needs 50%, Wants 30%, Save 20%',
        'Needs 30%, Wants 50%, Save 20%',
        'Needs 40%, Wants 40%, Save 20%'
      ],
      correctIndex: 0,
    ),
    QuizQuestion(
      id: 11,
      prompt: 'What is the fastest way to make a habit feel easier?',
      options: ['Do it for 2 minutes', 'Wait for motivation', 'Buy new gear'],
      correctIndex: 0,
    ),
    QuizQuestion(
      id: 12,
      prompt: 'Cold-water washing helps by:',
      options: ['Saving energy', 'Drying clothes faster', 'Adding fragrance'],
      correctIndex: 0,
    ),
  ];
}
