import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calendar_provider.dart';
import '../models/calendar.dart';
import 'new_calendar_screen.dart';

class CalendarsSheet extends StatelessWidget {
  const CalendarsSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 48,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text('Календари',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(flex: 2),
              ],
            ),
            const SizedBox(height: 8),
            const Text('Мои',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            ...provider.calendars
                .map((c) => _CalendarTile(calendar: c))
                .toList(),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.black,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const NewCalendarScreen()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Новый Календарь'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _CalendarTile extends StatelessWidget {
  final CalendarModel calendar;
  const _CalendarTile({required this.calendar});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CalendarProvider>(context);
    final selected = provider.selectedCalendar?.id == calendar.id;
    return InkWell(
      onTap: () => provider.selectCalendar(calendar.id),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: selected ? calendar.color : Colors.transparent,
                border: Border.all(color: calendar.color, width: 3),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(calendar.name, style: const TextStyle(fontSize: 16)),
            ),
            const Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
