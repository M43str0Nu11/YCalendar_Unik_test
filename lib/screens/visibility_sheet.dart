import 'package:flutter/material.dart';
import '../models/calendar.dart';

class VisibilitySheet extends StatelessWidget {
  final CalendarVisibility current;
  const VisibilitySheet({super.key, required this.current});

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
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text('Видимость',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                const Spacer(flex: 2),
                TextButton(
                  onPressed: () => Navigator.pop(context, current),
                  child: const Text('Сохранить',
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                )
              ],
            ),
            const SizedBox(height: 8),
            _option(
                context,
                CalendarVisibility.participants,
                'Только участникам',
                'Информацию о событии будут видеть только участники'),
            _option(context, CalendarVisibility.everyone, 'Всем',
                'Информацию о событии будут видеть все пользователи с доступом к вашему календарю'),
          ],
        ),
      ),
    );
  }

  Widget _option(BuildContext context, CalendarVisibility value, String title,
      String subtitle) {
    final selected = value == current;
    return InkWell(
      onTap: () => Navigator.pop(context, value),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 20,
              height: 20,
              margin: const EdgeInsets.only(top: 2),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade500),
                color: selected ? Colors.red : Colors.transparent,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 4),
                  Text(subtitle, style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
