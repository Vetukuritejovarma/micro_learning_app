import 'package:flutter/foundation.dart';

class NavigationController extends ValueNotifier<int> {
  NavigationController() : super(0);

  void goToHome() => value = 0;
  void goToLearn() => value = 1;
  void goToQuiz() => value = 2;
  void goToProgress() => value = 3;
}
