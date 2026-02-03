import '../models/progress_state.dart';
import '../repositories/progress_repository.dart';

class SaveProgress {
  final ProgressRepository repository;

  const SaveProgress(this.repository);

  Future<void> call(ProgressState state) {
    return repository.save(state);
  }
}
