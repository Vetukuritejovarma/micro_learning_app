import '../../domain/models/progress_state.dart';
import '../../domain/repositories/progress_repository.dart';
import '../datasources/local_storage.dart';

class ProgressRepositoryImpl implements ProgressRepository {
  final LocalStorageDataSource localStorage;

  ProgressRepositoryImpl(this.localStorage);

  @override
  Future<ProgressState> load() async {
    final stored = await localStorage.load();
    return stored ?? ProgressState.initial();
  }

  @override
  Future<void> save(ProgressState state) {
    return localStorage.save(state);
  }
}
