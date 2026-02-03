class UserProfile {
  final String name;
  final int dailyGoal;
  final bool remindersEnabled;
  final int reminderHour;
  final int reminderMinute;

  const UserProfile({
    required this.name,
    required this.dailyGoal,
    required this.remindersEnabled,
    required this.reminderHour,
    required this.reminderMinute,
  });

  UserProfile copyWith({
    String? name,
    int? dailyGoal,
    bool? remindersEnabled,
    int? reminderHour,
    int? reminderMinute,
  }) {
    return UserProfile(
      name: name ?? this.name,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      remindersEnabled: remindersEnabled ?? this.remindersEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
    );
  }
}
