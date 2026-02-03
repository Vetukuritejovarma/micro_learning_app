import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import '../../domain/models/user_profile.dart';
import '../../data/lesson_data.dart';
import '../state/progress_controller.dart';
import 'home_page.dart';
import 'learn_page.dart';
import 'progress_page.dart';
import 'quiz_page.dart';

class ShellScreen extends StatefulWidget {
  final ProgressController controller;
  final ValueNotifier<int> navIndex;

  const ShellScreen({super.key, required this.controller, required this.navIndex});

  @override
  State<ShellScreen> createState() => _ShellScreenState();
}

class _ShellScreenState extends State<ShellScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([widget.controller, widget.navIndex]),
      builder: (context, _) {
        if (widget.controller.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final state = widget.controller.state;
        final UserProfile profile = state.profile;

        final pages = [
          HomePage(
            xp: state.xp,
            streak: state.streak,
            dailyGoal: profile.dailyGoal,
            completedLessons: state.completedLessons,
            onComplete: widget.controller.completeLesson,
          ),
          LearnPage(
            completedLessons: state.completedLessons,
            onComplete: widget.controller.completeLesson,
          ),
          QuizPage(
            answers: state.quizAnswers,
            onAnswer: widget.controller.answerQuiz,
          ),
          ProgressPage(
            xp: state.xp,
            streak: state.streak,
            completedCount: state.completedLessons.length,
            totalCount: LessonData.lessons.length,
            profile: profile,
            steps: widget.controller.progressSteps,
            onGoalChanged: widget.controller.updateDailyGoal,
            onNameChanged: (name) {
              widget.controller.updateProfile(profile.copyWith(name: name));
            },
            onRemindersToggled: widget.controller.toggleReminders,
            onReminderTimeChanged: widget.controller.updateReminderTime,
            onDebugNotification: widget.controller.triggerDebugNotification,
          ),
        ];

        return DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF6F5F2), Color(0xFFE9F1FF)],
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBody: true,
            body: SafeArea(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 350),
                child: pages[widget.navIndex.value],
              ),
            ),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x22000000),
                    blurRadius: 18,
                    offset: Offset(0, 8),
                  )
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: widget.navIndex.value,
                onTap: (value) => setState(() => widget.navIndex.value = value),
                type: BottomNavigationBarType.fixed,
                elevation: 0,
                backgroundColor: Colors.transparent,
                selectedItemColor: const Color(0xFF1B5EFF),
                unselectedItemColor: const Color(0xFF8F8F99),
                items: const [
                  BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Home'),
                  BottomNavigationBarItem(icon: Icon(Icons.layers_rounded), label: 'Learn'),
                  BottomNavigationBarItem(icon: Icon(Icons.quiz_rounded), label: 'Quiz'),
                  BottomNavigationBarItem(icon: Icon(Icons.insights_rounded), label: 'Progress'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
