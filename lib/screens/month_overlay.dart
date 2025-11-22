import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import 'year_overlay.dart';

class MonthOverlay extends StatelessWidget {
  const MonthOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final displayed = provider.selectedDate;
    final year = displayed.year;
    final month = displayed.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday; // Mon=1

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
                Text('$year', style: AppTheme.h2),
                IconButton(
                  icon: const Icon(Icons.expand_more),
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const YearOverlay(),
                    );
                  },
                )
              ],
            ),
            Text(_monthName(month), style: AppTheme.h1),
            const SizedBox(height: 16),
            Row(
              children: const ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс']
                  .map((d) => Expanded(
                      child: Center(child: Text(d, style: AppTheme.caption))))
                  .toList(),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                ),
                itemCount: daysInMonth + (firstWeekday - 1),
                itemBuilder: (context, index) {
                  if (index < firstWeekday - 1) return const SizedBox.shrink();
                  final day = index - (firstWeekday - 2);
                  final date = DateTime(year, month, day);
                  final isSelected = provider.selectedDate.year == date.year &&
                      provider.selectedDate.month == date.month &&
                      provider.selectedDate.day == date.day;
                  return GestureDetector(
                    onTap: () {
                      provider.setSelectedDate(date);
                      Navigator.pop(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.primary.withValues(alpha: 0.15)
                            : AppTheme.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                      ),
                      child: Center(
                        child: Text('$day',
                            style: isSelected
                                ? AppTheme.body
                                    .copyWith(fontWeight: FontWeight.bold)
                                : AppTheme.body),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _monthName(int m) {
    const names = [
      'Январь',
      'Февраль',
      'Март',
      'Апрель',
      'Май',
      'Июнь',
      'Июль',
      'Август',
      'Сентябрь',
      'Октябрь',
      'Ноябрь',
      'Декабрь'
    ];
    return names[m - 1];
  }
}
