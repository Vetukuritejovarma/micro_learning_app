import '../models/progress_state.dart';
import '../repositories/progress_repository.dart';

class LoadProgress {
  final ProgressRepository repository;

  const LoadProgress(this.repository);

  Future<ProgressState> call() {
    return repository.load();
  }
}
