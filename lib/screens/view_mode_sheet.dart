import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ViewModeSheet extends StatelessWidget {
  const ViewModeSheet({super.key});

  static const modes = [
    '1 день',
    '3 дня',
    '5 дней',
    '7 дней',
    'Месяц',
    'Расписание',
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final m in modes)
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text(
                  m,
                  style: AppTheme.h2,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
