import 'package:flutter/material.dart';
import '../models/calendar.dart';
import 'value_picker_sheet.dart';
import 'unit_picker_sheet.dart';
import 'confirm_cancel_sheet.dart';

class AddReminderSheet extends StatefulWidget {
  const AddReminderSheet({super.key});

  @override
  State<AddReminderSheet> createState() => _AddReminderSheetState();
}

class _AddReminderSheetState extends State<AddReminderSheet> {
  int _value = 15;
  ReminderUnit _unit = ReminderUnit.minutes;
  ReminderChannel _channel = ReminderChannel.pushApp;

  @override
  Widget build(BuildContext context) {
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
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () async {
                    final confirm = await showModalBottomSheet<bool>(
                      context: context,
                      builder: (_) => const ConfirmCancelSheet(),
                    );
                    if (!mounted) return;
                    if (confirm == true) Navigator.pop(context);
                  },
                ),
                const Spacer(),
                const Text('Напоминание',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(flex: 2),
                TextButton(
                  onPressed: () {
                    final reminder =
                        Reminder(value: _value, unit: _unit, channel: _channel);
                    Navigator.pop(context, reminder);
                  },
                  child: const Text('Сохранить',
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                )
              ],
            ),
            const SizedBox(height: 16),
            const Text('Напомнить',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _PickerButton(
                    label: 'за $_value',
                    onTap: () async {
                      final v = await showModalBottomSheet<int>(
                        context: context,
                        builder: (_) => ValuePickerSheet(current: _value),
                      );
                      if (!mounted) return;
                      if (v != null) setState(() => _value = v);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _PickerButton(
                    label: _unitLabel(_unit),
                    onTap: () async {
                      final u = await showModalBottomSheet<ReminderUnit>(
                        context: context,
                        builder: (_) => UnitPickerSheet(current: _unit),
                      );
                      if (!mounted) return;
                      if (u != null) setState(() => _unit = u);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            const Text('Какое уведомление прислать',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            _radioChannel(ReminderChannel.pushApp, 'Пуш в приложении'),
            _radioChannel(ReminderChannel.email, 'Письмо на почту'),
            _radioChannel(ReminderChannel.caldav, 'Через CalDav'),
            _radioChannel(ReminderChannel.pushBrowser, 'Пуш в браузере'),
          ],
        ),
      ),
    );
  }

  Widget _radioChannel(ReminderChannel channel, String label) {
    final selected = _channel == channel;
    return InkWell(
      onTap: () => setState(() => _channel = channel),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade500),
                color: selected ? Colors.red : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(child: Text(label)),
          ],
        ),
      ),
    );
  }

  String _unitLabel(ReminderUnit unit) {
    switch (unit) {
      case ReminderUnit.moment:
        return 'момент';
      case ReminderUnit.minutes:
        return 'минут';
      case ReminderUnit.hours:
        return 'часов';
      case ReminderUnit.days:
        return 'дней';
      case ReminderUnit.weeks:
        return 'нед';
    }
  }
}

class _PickerButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _PickerButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          alignment: Alignment.center,
          child:
              Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
      ),
    );
  }
}
