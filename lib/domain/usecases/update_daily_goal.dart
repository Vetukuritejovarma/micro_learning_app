import '../models/progress_state.dart';

class UpdateDailyGoal {
  const UpdateDailyGoal();

  ProgressState call(ProgressState state, int dailyGoal) {
    final updatedProfile = state.profile.copyWith(dailyGoal: dailyGoal);
    return state.copyWith(profile: updatedProfile);
  }
}
