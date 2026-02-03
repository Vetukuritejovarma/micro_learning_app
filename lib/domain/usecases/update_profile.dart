import '../models/progress_state.dart';
import '../models/user_profile.dart';

class UpdateProfile {
  const UpdateProfile();

  ProgressState call(ProgressState state, UserProfile profile) {
    return state.copyWith(profile: profile);
  }
}
