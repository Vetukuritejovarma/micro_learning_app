import '../models/progress_state.dart';

class CompleteLesson {
  const CompleteLesson();

  ProgressState call(ProgressState state, int lessonId, int xpGain) {
    if (state.completedLessons.contains(lessonId)) return state;
    final updatedLessons = Set<int>.from(state.completedLessons)..add(lessonId);
    return state.copyWith(
      completedLessons: updatedLessons,
      xp: state.xp + xpGain,
      streak: state.streak + 1,
    );
  }
}
