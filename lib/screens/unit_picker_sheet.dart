import 'package:flutter/material.dart';
import '../models/calendar.dart';

class UnitPickerSheet extends StatelessWidget {
  final ReminderUnit current;
  const UnitPickerSheet({super.key, required this.current});

  @override
  Widget build(BuildContext context) {
    final units = [
      ReminderUnit.moment,
      ReminderUnit.minutes,
      ReminderUnit.hours,
      ReminderUnit.days,
      ReminderUnit.weeks,
    ];
    return SafeArea(
      child: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text('Тип',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(flex: 2),
              ],
            ),
          ),
          ...units.map((u) => ListTile(
                title: Text(_label(u)),
                trailing: u == current
                    ? const Icon(Icons.check, color: Colors.red)
                    : null,
                onTap: () => Navigator.pop(context, u),
              ))
        ],
      ),
    );
  }

  String _label(ReminderUnit u) {
    switch (u) {
      case ReminderUnit.moment:
        return 'В момент события';
      case ReminderUnit.minutes:
        return 'Минут';
      case ReminderUnit.hours:
        return 'Часов';
      case ReminderUnit.days:
        return 'Дней';
      case ReminderUnit.weeks:
        return 'Недель';
    }
  }
}
