import 'package:dynamic_app_icon_flutter_plus/dynamic_app_icon_flutter_plus.dart';

class AppIconOption {
  final String id;
  final String label;
  final String? iconName;

  const AppIconOption({required this.id, required this.label, this.iconName});
}

class AppIconService {
  static const options = [
    AppIconOption(id: 'default', label: 'Bolt + Book', iconName: null),
    AppIconOption(id: 'streak', label: 'Streak Flame', iconName: 'streak'),
    AppIconOption(id: 'xp', label: 'XP Badge', iconName: 'xp'),
    AppIconOption(id: 'quiz', label: 'Quiz Mode', iconName: 'quiz'),
    AppIconOption(id: 'night', label: 'Night Mode', iconName: 'night'),
    AppIconOption(id: 'goal', label: 'Goal Reached', iconName: 'goal'),
  ];

  Future<bool> supportsAlternateIcons() {
    return DynamicAppIconFlutterPlus.supportsAlternateIcons;
  }

  Future<String?> getCurrentIconName() {
    return DynamicAppIconFlutterPlus.getAlternateIconName();
  }

  Future<List<String>> getAvailableIcons() {
    return DynamicAppIconFlutterPlus.getAvailableIcons();
  }

  Future<void> setIcon(String? iconName) {
    return DynamicAppIconFlutterPlus.setAlternateIconName(iconName);
  }
}
