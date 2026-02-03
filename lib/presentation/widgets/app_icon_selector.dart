import 'package:flutter/material.dart';

import '../../core/services/app_icon_service.dart';

class AppIconSelector extends StatefulWidget {
  const AppIconSelector({super.key});

  @override
  State<AppIconSelector> createState() => _AppIconSelectorState();
}

class _AppIconSelectorState extends State<AppIconSelector> {
  final AppIconService _service = AppIconService();
  String? _current;
  bool _supported = false;
  bool _loading = true;
  Set<String> _available = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final supported = await _service.supportsAlternateIcons();
    String? current;
    if (supported) {
      current = await _service.getCurrentIconName();
    }
    final available = supported ? await _service.getAvailableIcons() : <String>[];
    if (!mounted) return;
    setState(() {
      _supported = supported;
      _current = current;
      _available = available.toSet();
      _loading = false;
    });
  }

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
          Text('App icon', style: theme.textTheme.titleMedium),
          const SizedBox(height: 6),
          Text(
            'Choose a mood for BiteQuest.',
            style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B6B75)),
          ),
          const SizedBox(height: 12),
          if (_loading)
            const Center(child: CircularProgressIndicator())
          else if (!_supported)
            Text(
              'Dynamic icons aren\'t supported on this device.',
              style: theme.textTheme.bodyMedium?.copyWith(color: const Color(0xFF6B6B75)),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppIconService.options.where((option) {
                if (option.iconName == null) return true;
                return _available.contains(option.iconName);
              }).map((option) {
                final selected = option.iconName == _current;
                return ChoiceChip(
                  label: Text(option.label),
                  selected: selected,
                  onSelected: (_) async {
                    await _service.setIcon(option.iconName);
                    if (!mounted) return;
                    setState(() {
                      _current = option.iconName;
                    });
                  },
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
