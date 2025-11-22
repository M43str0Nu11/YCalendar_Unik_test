import 'package:flutter/material.dart';
import '../models/event.dart';
import '../theme/app_theme.dart';

class EventDetailsSheet extends StatelessWidget {
  final Event event;
  const EventDetailsSheet({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final start = event.startTime;
    final end = event.endTime;
    String timeRange = '';
    if (start != null) {
      timeRange =
          '${start.hour.toString().padLeft(2, '0')}:${start.minute.toString().padLeft(2, '0')}';
      if (end != null) {
        timeRange +=
            ' - ${end.hour.toString().padLeft(2, '0')}:${end.minute.toString().padLeft(2, '0')}';
      }
    } else {
      timeRange = 'Без времени';
    }
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(event.title, style: AppTheme.h2),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(timeRange, style: AppTheme.bodySecondary),
            const SizedBox(height: 12),
            if (event.description != null &&
                event.description!.trim().isNotEmpty)
              Text(event.description!, style: AppTheme.body),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.edit),
                    label: const Text('Редактировать'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Could implement delete via provider if needed
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.delete_outline),
                    label: const Text('Закрыть'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
