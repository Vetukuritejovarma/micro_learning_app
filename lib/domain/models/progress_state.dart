import 'user_profile.dart';

class ProgressState {
  final int xp;
  final int streak;
  final Set<int> completedLessons;
  final Map<int, int> quizAnswers;
  final UserProfile profile;

  const ProgressState({
    required this.xp,
    required this.streak,
    required this.completedLessons,
    required this.quizAnswers,
    required this.profile,
  });

  ProgressState copyWith({
    int? xp,
    int? streak,
    Set<int>? completedLessons,
    Map<int, int>? quizAnswers,
    UserProfile? profile,
  }) {
    return ProgressState(
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      completedLessons: completedLessons ?? this.completedLessons,
      quizAnswers: quizAnswers ?? this.quizAnswers,
      profile: profile ?? this.profile,
    );
  }

  static ProgressState initial() {
    return const ProgressState(
      xp: 120,
      streak: 4,
      completedLessons: {},
      quizAnswers: {},
      profile: UserProfile(
        name: 'Learner',
        dailyGoal: 15,
        remindersEnabled: false,
        reminderHour: 9,
        reminderMinute: 0,
      ),
    );
  }
}
