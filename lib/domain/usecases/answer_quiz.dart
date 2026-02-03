import '../models/progress_state.dart';

class AnswerQuiz {
  const AnswerQuiz();

  ProgressState call(ProgressState state, int questionId, int selectedIndex, int correctIndex) {
    if (state.quizAnswers.containsKey(questionId)) return state;
    final updatedAnswers = Map<int, int>.from(state.quizAnswers)
      ..[questionId] = selectedIndex;
    final gainedXp = selectedIndex == correctIndex ? 12 : 0;
    return state.copyWith(
      quizAnswers: updatedAnswers,
      xp: state.xp + gainedXp,
    );
  }
}
