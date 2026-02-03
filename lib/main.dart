import 'dart:io';

import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';

import 'core/services/quick_action_service.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'data/datasources/local_storage.dart';
import 'data/repositories/progress_repository_impl.dart';
import 'presentation/screens/shell_screen.dart';
import 'presentation/state/navigation_controller.dart';
import 'presentation/state/progress_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BiteQuestApp());
}

class BiteQuestApp extends StatefulWidget {
  const BiteQuestApp({super.key});

  @override
  State<BiteQuestApp> createState() => _BiteQuestAppState();
}

class _BiteQuestAppState extends State<BiteQuestApp> {
  late final ProgressController _controller;
  late final NavigationController _navigationController;
  late final QuickActionService _quickActionService;

  @override
  void initState() {
    super.initState();
    final repository = ProgressRepositoryImpl(LocalStorageDataSource());
    _controller = ProgressController(
      repository: repository,
      notificationService: NotificationService(),
    );
    _navigationController = NavigationController();
    _quickActionService = QuickActionService(_navigationController);
    _quickActionService.register();
    if (Platform.isIOS) {
      HomeWidget.setAppGroupId('group.com.bitequest.app');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BiteQuest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      home: ShellScreen(controller: _controller, navIndex: _navigationController),
    );
  }
}
