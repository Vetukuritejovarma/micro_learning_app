import 'package:flutter/foundation.dart';
import 'package:home_widget/home_widget.dart';

import '../../core/services/notification_service.dart';
import '../../data/repositories/progress_repository_impl.dart';
import '../../domain/models/progress_state.dart';
import '../../domain/models/user_profile.dart';
import '../../domain/usecases/answer_quiz.dart';
import '../../domain/usecases/complete_lesson.dart';
import '../../domain/usecases/load_progress.dart';
import '../../domain/usecases/save_progress.dart';
import '../../domain/usecases/update_daily_goal.dart';
import '../../domain/usecases/update_profile.dart';

class ProgressController extends ChangeNotifier {
  final LoadProgress _loadProgress;
  final SaveProgress _saveProgress;
  final CompleteLesson _completeLesson;
  final AnswerQuiz _answerQuiz;
  final UpdateProfile _updateProfile;
  final UpdateDailyGoal _updateDailyGoal;
  final NotificationService _notificationService;

  ProgressState _state = ProgressState.initial();
  bool _isLoading = true;

  ProgressController({
    required ProgressRepositoryImpl repository,
    required NotificationService notificationService,
  })  : _loadProgress = LoadProgress(repository),
        _saveProgress = SaveProgress(repository),
        _completeLesson = const CompleteLesson(),
        _answerQuiz = const AnswerQuiz(),
        _updateProfile = const UpdateProfile(),
        _updateDailyGoal = const UpdateDailyGoal(),
        _notificationService = notificationService;

  ProgressState get state => _state;
  bool get isLoading => _isLoading;
  List<ProgressStep> get progressSteps => _buildProgressSteps(_state);

  Future<void> initialize() async {
    _state = await _loadProgress();
    _isLoading = false;
    notifyListeners();
    await _updateWidgets(_state);

    await _notificationService.initialize();
    if (_state.profile.remindersEnabled) {
      await _notificationService.scheduleDailyReminder(
        hour: _state.profile.reminderHour,
        minute: _state.profile.reminderMinute,
        steps: _buildProgressSteps(_state),
      );
    }
  }

  Future<void> completeLesson(int lessonId, int xpGain) async {
    final updated = _completeLesson(_state, lessonId, xpGain);
    await _commit(updated);
  }

  Future<void> answerQuiz(int questionId, int selectedIndex, int correctIndex) async {
    final updated = _answerQuiz(_state, questionId, selectedIndex, correctIndex);
    await _commit(updated);
  }

  Future<void> updateDailyGoal(int dailyGoal) async {
    final updated = _updateDailyGoal(_state, dailyGoal);
    await _commit(updated);
  }

  Future<void> updateProfile(UserProfile profile) async {
    final updated = _updateProfile(_state, profile);
    await _commit(updated);
  }

  Future<void> toggleReminders(bool enabled) async {
    if (enabled) {
      final granted = await _notificationService.requestPermissions();
      if (!granted) {
        final disabledProfile = _state.profile.copyWith(remindersEnabled: false);
        await _commit(_state.copyWith(profile: disabledProfile), scheduleNotifications: false);
        return;
      }
      final updatedProfile = _state.profile.copyWith(remindersEnabled: true);
      await _commit(_state.copyWith(profile: updatedProfile), scheduleNotifications: true);
    } else {
      final updatedProfile = _state.profile.copyWith(remindersEnabled: false);
      await _commit(_state.copyWith(profile: updatedProfile), scheduleNotifications: false);
      await _notificationService.cancelDailyReminder();
    }
  }

  Future<void> updateReminderTime(int hour, int minute) async {
    final updatedProfile = _state.profile.copyWith(reminderHour: hour, reminderMinute: minute);
    final updated = _state.copyWith(profile: updatedProfile);
    await _commit(updated, scheduleNotifications: updatedProfile.remindersEnabled);
  }

  Future<void> triggerDebugNotification() async {
    await _notificationService.showDebugNotification(steps: _buildProgressSteps(_state));
  }

  Future<void> _commit(ProgressState updated, {bool scheduleNotifications = true}) async {
    _state = updated;
    notifyListeners();
    await _saveProgress(_state);
    await _updateWidgets(_state);
    if (scheduleNotifications && _state.profile.remindersEnabled) {
      await _notificationService.scheduleDailyReminder(
        hour: _state.profile.reminderHour,
        minute: _state.profile.reminderMinute,
        steps: _buildProgressSteps(_state),
      );
    }
  }

  List<ProgressStep> _buildProgressSteps(ProgressState state) {
    final hasLesson = state.completedLessons.isNotEmpty;
    final hasQuiz = state.quizAnswers.isNotEmpty;
    final goalMet = state.completedLessons.length >= state.profile.dailyGoal;

    return [
      const ProgressStep('Open BiteQuest', true),
      ProgressStep('Pick a lesson', hasLesson),
      ProgressStep('Complete lesson', hasLesson),
      ProgressStep('Take quick quiz', hasQuiz),
      ProgressStep('Update streak', goalMet),
    ];
  }

  Future<void> _updateWidgets(ProgressState state) async {
    final steps = _buildProgressSteps(state);
    final stepsText = steps.map((step) => '${step.done ? '●' : '○'} ${step.label}').join(' | ');
    final progress = steps.isEmpty ? 0 : (steps.where((step) => step.done).length * 100 ~/ steps.length);

    await HomeWidget.saveWidgetData('xp', state.xp);
    await HomeWidget.saveWidgetData('streak', state.streak);
    await HomeWidget.saveWidgetData('steps', stepsText);
    await HomeWidget.saveWidgetData('progress', progress);
    await HomeWidget.updateWidget(name: 'BiteQuestWidgetProvider');
    await HomeWidget.updateWidget(name: 'BiteQuestStepsWidgetProvider');
  }
}
