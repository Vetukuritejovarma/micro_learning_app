import 'package:flutter/foundation.dart';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class ProgressStep {
  final String label;
  final bool done;

  const ProgressStep(this.label, this.done);
}

class NotificationService {
  static const _channelId = 'bitequest_daily';
  static const _channelName = 'Daily reminders';
  static const _channelDescription = 'Daily learning reminders for BiteQuest.';
  static const _notificationId = 1201;

  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const settings = InitializationSettings(android: androidSettings);
    await _plugin.initialize(settings);

    if (!kIsWeb) {
      tz.initializeTimeZones();
      try {
        final timeZoneName = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(timeZoneName as String));
      } catch (_) {
        tz.setLocalLocation(tz.UTC);
      }
    }
  }

  Future<bool> requestPermissions() async {
    final androidPlugin = _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final granted = await androidPlugin?.requestNotificationsPermission() ?? true;
    return granted;
  }

  Future<void> scheduleDailyReminder({
    required int hour,
    required int minute,
    required List<ProgressStep> steps,
  }) async {
    await _plugin.cancel(_notificationId);

    final scheduled = _nextInstance(hour, minute);
    final body = _buildProgressBody(steps);
    final doneCount = steps.where((step) => step.done).length;

    final progressBytes = await _buildProgressImage(doneCount, steps.length);
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showProgress: false,
      onlyAlertOnce: true,
      color: const Color(0xFF2EC4B6),
      colorized: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigPictureStyleInformation(
        ByteArrayAndroidBitmap(progressBytes),
        contentTitle: 'Your BiteQuest path',
        summaryText: body,
        htmlFormatSummaryText: false,
        hideExpandedLargeIcon: true,
      ),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      threadIdentifier: 'bitequest_path',
    );

    await _plugin.zonedSchedule(
      _notificationId,
      'Your BiteQuest path',
      body,
      scheduled,
       NotificationDetails(android: androidDetails, iOS: iosDetails),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  Future<void> cancelDailyReminder() async {
    await _plugin.cancel(_notificationId);
  }

  Future<void> showDebugNotification({required List<ProgressStep> steps}) async {
    final body = _buildProgressBody(steps);
    final doneCount = steps.where((step) => step.done).length;

    final progressBytes = await _buildProgressImage(doneCount, steps.length);
    final androidDetails = AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      showProgress: false,
      onlyAlertOnce: true,
      color: const Color(0xFF2EC4B6),
      colorized: true,
      largeIcon: const DrawableResourceAndroidBitmap('@mipmap/ic_launcher'),
      styleInformation: BigPictureStyleInformation(
        ByteArrayAndroidBitmap(progressBytes),
        contentTitle: 'Your BiteQuest path',
        summaryText: body,
        htmlFormatSummaryText: false,
        hideExpandedLargeIcon: true,
      ),
    );
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentSound: true,
      presentBadge: true,
      threadIdentifier: 'bitequest_path',
    );

    await _plugin.show(
      _notificationId,
      'Your BiteQuest path',
      body,
       NotificationDetails(android: androidDetails, iOS: iosDetails),
    );
  }

  tz.TZDateTime _nextInstance(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled = tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }

  String _buildProgressBody(List<ProgressStep> steps) {
    return steps
        .map((step) => '${step.done ? '✅' : '⬜'} ${step.label}')
        .join('\n');
  }

  Future<Uint8List> _buildProgressImage(int done, int total) async {
    const width = 900.0;
    const height = 140.0;
    const padding = 24.0;
    const barHeight = 28.0;
    final progress = total == 0 ? 0.0 : done / total;

    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final trackPaint = ui.Paint()..color = const Color(0xFFE6E6EC);
    final fillPaint = ui.Paint()..color = const Color(0xFF2EC4B6);
    final radius = const ui.Radius.circular(18);
    final rect = ui.Rect.fromLTWH(padding, (height - barHeight) / 2, width - padding * 2, barHeight);

    final trackRRect = ui.RRect.fromRectAndRadius(rect, radius);
    canvas.drawRRect(trackRRect, trackPaint);

    final fillWidth = rect.width * progress;
    if (fillWidth > 0) {
      final fillRect = ui.Rect.fromLTWH(rect.left, rect.top, fillWidth, rect.height);
      final fillRRect = ui.RRect.fromRectAndRadius(fillRect, radius);
      canvas.drawRRect(fillRRect, fillPaint);
    }

    final picture = recorder.endRecording();
    final image = await picture.toImage(width.toInt(), height.toInt());
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    return bytes!.buffer.asUint8List();
  }
}
