import 'package:quick_actions/quick_actions.dart';

import '../../presentation/state/navigation_controller.dart';

class QuickActionService {
  final QuickActions _quickActions = const QuickActions();
  final NavigationController _navigationController;

  QuickActionService(this._navigationController);

  void register() {
    _quickActions.initialize((type) {
      switch (type) {
        case 'start_lesson':
          _navigationController.goToLearn();
          break;
        case 'take_quiz':
          _navigationController.goToQuiz();
          break;
        case 'view_progress':
        case 'set_goal':
        case 'reminder_settings':
          _navigationController.goToProgress();
          break;
        default:
          _navigationController.goToHome();
      }
    });

    _quickActions.setShortcutItems(
      const [
        ShortcutItem(type: 'start_lesson', localizedTitle: 'Start Lesson', icon: 'ic_shortcut_lesson'),
        ShortcutItem(type: 'take_quiz', localizedTitle: 'Take Quiz', icon: 'ic_shortcut_quiz'),
        ShortcutItem(type: 'view_progress', localizedTitle: 'View Progress', icon: 'ic_shortcut_progress'),
        ShortcutItem(type: 'set_goal', localizedTitle: 'Set Daily Goal', icon: 'ic_shortcut_goal'),
        ShortcutItem(type: 'reminder_settings', localizedTitle: 'Reminder Settings', icon: 'ic_shortcut_reminder'),
      ],
    );
  }
}
