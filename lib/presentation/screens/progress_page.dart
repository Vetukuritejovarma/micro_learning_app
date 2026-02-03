import 'package:flutter/material.dart';

import '../../core/services/notification_service.dart';
import '../../domain/models/user_profile.dart';
import '../widgets/app_icon_selector.dart';
import '../widgets/progress_tile.dart';

class ProgressPage extends StatelessWidget {
  final int xp;
  final int streak;
  final int completedCount;
  final int totalCount;
  final UserProfile profile;
  final List<ProgressStep> steps;
  final ValueChanged<int> onGoalChanged;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<bool> onRemindersToggled;
  final void Function(int hour, int minute) onReminderTimeChanged;
  final VoidCallback onDebugNotification;

  const ProgressPage({
    super.key,
    required this.xp,
    required this.streak,
    required this.completedCount,
    required this.totalCount,
    required this.profile,
    required this.steps,
    required this.onGoalChanged,
    required this.onNameChanged,
    required this.onRemindersToggled,
    required this.onReminderTimeChanged,
    required this.onDebugNotification,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final progress = totalCount == 0 ? 0.0 : completedCount / totalCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 120),
      children: [
        Text(
          'Progress',
          style: theme.textTheme.headlineLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 16),
        _ProfileCard(profile: profile, onNameChanged: onNameChanged),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('XP Bank', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              Text(
                '$xp XP',
                style: theme.textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: (progress + 0.1).clamp(0.0, 1.0),
                minHeight: 10,
                borderRadius: BorderRadius.circular(12),
                backgroundColor: const Color(0xFFE6E6EC),
                color: const Color(0xFF1B5EFF),
              ),
              const SizedBox(height: 8),
              Text('$completedCount of $totalCount lessons completed'),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ProgressTile(
                title: 'Streak',
                value: '$streak days',
                icon: Icons.local_fire_department_rounded,
                color: const Color(0xFFFF8A3D),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ProgressTile(
                title: 'Daily goal',
                value: '${profile.dailyGoal} lessons',
                icon: Icons.flag_rounded,
                color: const Color(0xFF1B5EFF),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _GoalCard(
          dailyGoal: profile.dailyGoal,
          onGoalChanged: onGoalChanged,
        ),
        const SizedBox(height: 16),
        _ProgressTimeline(steps: steps),
        const SizedBox(height: 16),
        const AppIconSelector(),
        const SizedBox(height: 16),
        _ReminderCard(
          profile: profile,
          onRemindersToggled: onRemindersToggled,
          onReminderTimeChanged: onReminderTimeChanged,
        ),
        const SizedBox(height: 16),
        _DebugCard(onDebugNotification: onDebugNotification),
      ],
    );
  }
}

class _ProgressTimeline extends StatelessWidget {
  final List<ProgressStep> steps;

  const _ProgressTimeline({required this.steps});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final doneCount = steps.where((step) => step.done).length;
    final progress = steps.isEmpty ? 0.0 : doneCount / steps.length;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Your path', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Follow the steps like a ride timeline.',
            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B6B75)),
          ),
          const SizedBox(height: 12),
          TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: progress),
            duration: const Duration(milliseconds: 600),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 10,
                borderRadius: BorderRadius.circular(12),
                backgroundColor: const Color(0xFFE6E6EC),
                color: const Color(0xFF1B5EFF),
              );
            },
          ),
          const SizedBox(height: 16),
          ...steps.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;
            final isLast = index == steps.length - 1;
            return _TimelineRow(step: step, isLast: isLast);
          }),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final ProgressStep step;
  final bool isLast;

  const _TimelineRow({required this.step, required this.isLast});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dotColor = step.done ? const Color(0xFF1B5EFF) : const Color(0xFFB8B8C4);
    final lineColor = step.done ? const Color(0xFF1B5EFF) : const Color(0xFFE0E0E6);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: dotColor,
              ),
              child: step.done
                  ? const Icon(Icons.check, size: 12, color: Colors.white)
                  : const SizedBox.shrink(),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 28,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: lineColor,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Text(
              step.label,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: step.done ? FontWeight.w600 : FontWeight.w400,
                color: step.done ? const Color(0xFF1B1B1F) : const Color(0xFF7C7C86),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _ProfileCard extends StatelessWidget {
  final UserProfile profile;
  final ValueChanged<String> onNameChanged;

  const _ProfileCard({required this.profile, required this.onNameChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF5E9),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFF1B5EFF),
            child: Text(
              profile.name.isNotEmpty ? profile.name.substring(0, 1).toUpperCase() : 'B',
              style: theme.textTheme.titleMedium?.copyWith(color: Colors.white),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Welcome back,', style: theme.textTheme.bodyMedium),
                Text(
                  profile.name,
                  style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () async {
              final controller = TextEditingController(text: profile.name);
              final result = await showDialog<String>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Edit name'),
                  content: TextField(
                    controller: controller,
                    textInputAction: TextInputAction.done,
                    decoration: const InputDecoration(hintText: 'Your name'),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(controller.text.trim()),
                      child: const Text('Save'),
                    )
                  ],
                ),
              );
              if (result != null && result.isNotEmpty) {
                onNameChanged(result);
              }
            },
          )
        ],
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  final int dailyGoal;
  final ValueChanged<int> onGoalChanged;

  const _GoalCard({required this.dailyGoal, required this.onGoalChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Set a new goal', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Choose how many lessons feel right each day.',
            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B6B75)),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [5, 10, 15, 20].map((value) {
              final selected = value == dailyGoal;
              return ChoiceChip(
                label: Text('$value'),
                selected: selected,
                onSelected: (_) => onGoalChanged(value),
                selectedColor: const Color(0xFF1B5EFF),
                labelStyle: TextStyle(
                  color: selected ? Colors.white : const Color(0xFF1B1B1F),
                ),
              );
            }).toList(),
          )
        ],
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final UserProfile profile;
  final ValueChanged<bool> onRemindersToggled;
  final void Function(int hour, int minute) onReminderTimeChanged;

  const _ReminderCard({
    required this.profile,
    required this.onRemindersToggled,
    required this.onReminderTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeLabel = _formatTime(context, profile.reminderHour, profile.reminderMinute);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('Daily reminder', style: theme.textTheme.titleMedium),
              const Spacer(),
              Switch(
                value: profile.remindersEnabled,
                onChanged: onRemindersToggled,
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            'A nudge to keep your streak alive.',
            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B6B75)),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Text('Time: $timeLabel', style: theme.textTheme.titleSmall),
              const Spacer(),
              TextButton(
                onPressed: () async {
                  final picked = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay(hour: profile.reminderHour, minute: profile.reminderMinute),
                  );
                  if (picked != null) {
                    onReminderTimeChanged(picked.hour, picked.minute);
                  }
                },
                child: const Text('Change'),
              )
            ],
          )
        ],
      ),
    );
  }

  String _formatTime(BuildContext context, int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    return MaterialLocalizations.of(context).formatTimeOfDay(time);
  }
}

class _DebugCard extends StatelessWidget {
  final VoidCallback onDebugNotification;

  const _DebugCard({required this.onDebugNotification});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F1FF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Debug tools', style: theme.textTheme.titleMedium),
                const SizedBox(height: 6),
                Text(
                  'Trigger the notification instantly.',
                  style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B6B75)),
                ),
              ],
            ),
          ),
          FilledButton(
            onPressed: onDebugNotification,
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF1B5EFF),
            ),
            child: const Text('Test'),
          ),
        ],
      ),
    );
  }
}
