import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/theme/app_colors.dart';

/// User-selected session duration.
final sessionDurationProvider = StateProvider<int>((ref) => 30);

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final duration = ref.watch(sessionDurationProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // Session duration
          _SettingsSection(
            title: 'Session Duration',
            child: SegmentedButton<int>(
              segments: const [
                ButtonSegment(value: 30, label: Text('30 min')),
                ButtonSegment(value: 45, label: Text('45 min')),
                ButtonSegment(value: 60, label: Text('60 min')),
              ],
              selected: {duration},
              onSelectionChanged: (values) {
                ref.read(sessionDurationProvider.notifier).state =
                    values.first;
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return AppColors.primary;
                  }
                  return AppColors.cardDark;
                }),
              ),
            ),
          ),
          const SizedBox(height: 24),

          // About
          const _SettingsSection(
            title: 'About',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'CORTEX v0.1.0',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Daily cognitive training for robotics/AI professionals.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final Widget child;

  const _SettingsSection({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: AppColors.textMuted,
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 10),
        child,
      ],
    );
  }
}
