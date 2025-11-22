import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/calendar_provider.dart';
import '../models/calendar.dart';
import 'add_reminder_sheet.dart';
import 'visibility_sheet.dart';
import 'duration_sheet.dart';

class NewCalendarScreen extends StatefulWidget {
  const NewCalendarScreen({super.key});

  @override
  State<NewCalendarScreen> createState() => _NewCalendarScreenState();
}

class _NewCalendarScreenState extends State<NewCalendarScreen> {
  final _nameController = TextEditingController();
  Color _selectedColor = const Color(0xFFF44336);
  CalendarVisibility _visibility = CalendarVisibility.participants;
  int _defaultDuration = 30;
  bool _notifyUnaccepted = false;
  bool _isPrimary = false;
  final List<Reminder> _reminders = [];

  final _colors = const [
    Color(0xFFF44336), // red
    Color(0xFFFFD3D3), // light pink
    Color(0xFFFF7A23), // orange
    Color(0xFFFFB300), // amber
    Color(0xFFE0DE43), // yellow
    Color(0xFF14B463), // green (kept)
  ];

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F8),
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Новый календарь'),
        actions: [
          TextButton(
            onPressed: () {
              if (_nameController.text.trim().isEmpty) return;
              final provider =
                  Provider.of<CalendarProvider>(context, listen: false);
              final model = provider
                  .addCalendar(
                      name: _nameController.text.trim(), color: _selectedColor)
                  .copyWith(
                    visibility: _visibility,
                    defaultMeetingMinutes: _defaultDuration,
                    notifyUnaccepted: _notifyUnaccepted,
                    isPrimary: _isPrimary,
                    reminders: _reminders,
                  );
              provider.updateCalendar(model);
              Navigator.pop(context);
            },
            child: const Text('Создать',
                style: TextStyle(color: Colors.red, fontSize: 16)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Название календаря',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12))),
              ),
            ),
            const SizedBox(height: 16),
            _SectionCard(
              title: 'Цвет календаря',
              child: Wrap(
                spacing: 12,
                children: _colors
                    .map((c) => GestureDetector(
                          onTap: () => setState(() => _selectedColor = c),
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: c,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == c
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                            foregroundDecoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: _selectedColor == c
                                    ? c
                                    : Colors.transparent,
                                width: 3,
                              ),
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
            const SizedBox(height: 12),
            _SectionCard(
              title: 'Напоминать мне о событиях',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _reminders
                        .map((r) => Chip(
                              label: Text(_reminderLabel(r)),
                              deleteIcon: const Icon(Icons.close),
                              onDeleted: () =>
                                  setState(() => _reminders.remove(r)),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () async {
                      final reminder = await showModalBottomSheet<Reminder>(
                        context: context,
                        isScrollControlled: true,
                        builder: (_) => const AddReminderSheet(),
                      );
                      if (reminder != null) {
                        setState(() => _reminders.add(reminder));
                      }
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Добавить напоминание'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            _NavTile(
              title: 'Видимость календаря',
              value: _visibility == CalendarVisibility.participants
                  ? 'Только участникам'
                  : 'Всем',
              onTap: () async {
                final vis = await showModalBottomSheet<CalendarVisibility>(
                  context: context,
                  builder: (_) => VisibilitySheet(current: _visibility),
                );
                if (vis != null) setState(() => _visibility = vis);
              },
            ),
            _NavTile(
              title: 'Длительность встречи по умолчанию',
              value: '$_defaultDuration минут',
              onTap: () async {
                final duration = await showModalBottomSheet<int>(
                  context: context,
                  builder: (_) => DurationSheet(current: _defaultDuration),
                );
                if (duration != null) {
                  setState(() => _defaultDuration = duration);
                }
              },
            ),
            SwitchListTile(
              title: const Text('Уведомлять о непринятых событиях'),
              value: _notifyUnaccepted,
              onChanged: (v) => setState(() => _notifyUnaccepted = v),
            ),
            SwitchListTile(
              title: const Text('Использовать календарь как основной'),
              value: _isPrimary,
              onChanged: (v) => setState(() => _isPrimary = v),
            ),
          ],
        ),
      ),
    );
  }

  String _reminderLabel(Reminder r) {
    if (r.unit == ReminderUnit.moment) return 'В момент события';
    String unit;
    switch (r.unit) {
      case ReminderUnit.minutes:
        unit = 'мин';
        break;
      case ReminderUnit.hours:
        unit = 'час';
        break;
      case ReminderUnit.days:
        unit = 'дн';
        break;
      case ReminderUnit.weeks:
        unit = 'нед';
        break;
      case ReminderUnit.moment:
        unit = '';
        break;
    }
    return 'за ${r.value} $unit';
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  const _SectionCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  final String title;
  final String value;
  final VoidCallback onTap;
  const _NavTile(
      {required this.title, required this.value, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        onTap: onTap,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(value),
        trailing: const Icon(Icons.chevron_right),
      ),
    );
  }
}
