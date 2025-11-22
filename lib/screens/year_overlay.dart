import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';

class YearOverlay extends StatefulWidget {
  const YearOverlay({super.key});
  @override
  State<YearOverlay> createState() => _YearOverlayState();
}

class _YearOverlayState extends State<YearOverlay> {
  late DateTime _pivot; // year displayed

  @override
  void initState() {
    super.initState();
    final provider = Provider.of<EventProvider>(context, listen: false);
    _pivot = DateTime(provider.selectedDate.year, 1, 1);
  }

  void prevYear() => setState(() => _pivot = DateTime(_pivot.year - 1, 1, 1));
  void nextYear() => setState(() => _pivot = DateTime(_pivot.year + 1, 1, 1));

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final months = List.generate(12, (i) => DateTime(_pivot.year, i + 1, 1));
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                    icon: const Icon(Icons.chevron_left), onPressed: prevYear),
                Expanded(
                    child: Center(
                        child: Text('${_pivot.year}', style: AppTheme.h2))),
                IconButton(
                    icon: const Icon(Icons.chevron_right), onPressed: nextYear),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.6,
                ),
                itemCount: months.length,
                itemBuilder: (context, index) {
                  final m = months[index];
                  final isCurrent = provider.selectedDate.year == m.year &&
                      provider.selectedDate.month == m.month;
                  return GestureDetector(
                    onTap: () {
                      provider.setSelectedDate(
                          DateTime(m.year, m.month, provider.selectedDate.day));
                      Navigator.pop(context); // close year overlay
                      Navigator.pop(context); // close month overlay underneath
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isCurrent
                            ? AppTheme.primary.withValues(alpha: 0.15)
                            : AppTheme.white,
                        borderRadius: BorderRadius.circular(AppTheme.radiusSm),
                        border: Border.all(color: AppTheme.border),
                      ),
                      alignment: Alignment.center,
                      child: Text(_shortMonthName(m.month),
                          style: isCurrent
                              ? AppTheme.body
                                  .copyWith(fontWeight: FontWeight.bold)
                              : AppTheme.body),
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

  String _shortMonthName(int m) {
    const names = [
      'Янв',
      'Фев',
      'Мар',
      'Апр',
      'Май',
      'Июн',
      'Июл',
      'Авг',
      'Сен',
      'Окт',
      'Ноя',
      'Дек'
    ];
    return names[m - 1];
  }
}
