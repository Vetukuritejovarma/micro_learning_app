import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../domain/models/progress_state.dart';
import '../../domain/models/user_profile.dart';

class LocalStorageDataSource {
  static const _xpKey = 'xp';
  static const _streakKey = 'streak';
  static const _completedLessonsKey = 'completedLessons';
  static const _quizAnswersKey = 'quizAnswers';
  static const _nameKey = 'profileName';
  static const _dailyGoalKey = 'dailyGoal';
  static const _remindersEnabledKey = 'remindersEnabled';
  static const _reminderHourKey = 'reminderHour';
  static const _reminderMinuteKey = 'reminderMinute';

  Future<ProgressState?> load() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_xpKey)) return null;

    final xp = prefs.getInt(_xpKey) ?? 0;
    final streak = prefs.getInt(_streakKey) ?? 0;
    final completedLessons = prefs.getStringList(_completedLessonsKey) ?? [];
    final quizAnswersJson = prefs.getString(_quizAnswersKey);
    final name = prefs.getString(_nameKey) ?? 'Learner';
    final dailyGoal = prefs.getInt(_dailyGoalKey) ?? 15;
    final remindersEnabled = prefs.getBool(_remindersEnabledKey) ?? false;
    final reminderHour = prefs.getInt(_reminderHourKey) ?? 9;
    final reminderMinute = prefs.getInt(_reminderMinuteKey) ?? 0;

    final decodedAnswers = quizAnswersJson == null
        ? <String, dynamic>{}
        : jsonDecode(quizAnswersJson) as Map<String, dynamic>;

    return ProgressState(
      xp: xp,
      streak: streak,
      completedLessons: completedLessons.map(int.parse).toSet(),
      quizAnswers: decodedAnswers.map((key, value) => MapEntry(int.parse(key), value as int)),
      profile: UserProfile(
        name: name,
        dailyGoal: dailyGoal,
        remindersEnabled: remindersEnabled,
        reminderHour: reminderHour,
        reminderMinute: reminderMinute,
      ),
    );
  }

  Future<void> save(ProgressState state) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setInt(_xpKey, state.xp);
    await prefs.setInt(_streakKey, state.streak);
    await prefs.setStringList(
      _completedLessonsKey,
      state.completedLessons.map((id) => id.toString()).toList(),
    );
    final encodedAnswers = state.quizAnswers.map((key, value) => MapEntry(key.toString(), value));
    await prefs.setString(_quizAnswersKey, jsonEncode(encodedAnswers));
    await prefs.setString(_nameKey, state.profile.name);
    await prefs.setInt(_dailyGoalKey, state.profile.dailyGoal);
    await prefs.setBool(_remindersEnabledKey, state.profile.remindersEnabled);
    await prefs.setInt(_reminderHourKey, state.profile.reminderHour);
    await prefs.setInt(_reminderMinuteKey, state.profile.reminderMinute);
  }
}
