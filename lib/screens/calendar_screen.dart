import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../theme/app_theme.dart';
import 'create_event_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime displayedMonth = DateTime.now();
  DateTime? selectedDate;

  void nextMonth() {
    setState(() {
      displayedMonth =
          DateTime(displayedMonth.year, displayedMonth.month + 1, 1);
    });
  }

  void prevMonth() {
    setState(() {
      displayedMonth =
          DateTime(displayedMonth.year, displayedMonth.month - 1, 1);
    });
  }

  void goToToday() {
    setState(() {
      displayedMonth = DateTime.now();
      selectedDate = DateTime.now();
    });
  }

  List<String> weekDays = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<EventProvider>(context);
    final year = displayedMonth.year;
    final month = displayedMonth.month;
    final daysInMonth = DateTime(year, month + 1, 0).day;
    final firstWeekday = DateTime(year, month, 1).weekday;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Text('${_monthName(month)} $year'),
        actions: [
          TextButton(
            onPressed: goToToday,
            child: const Text('Сегодня',
                style: TextStyle(color: AppTheme.primary)),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: prevMonth,
                        icon: const Icon(Icons.chevron_left),
                        color: AppTheme.primaryText,
                      ),
                      Text(
                        '${_monthName(month)} $year',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      IconButton(
                        onPressed: nextMonth,
                        icon: const Icon(Icons.chevron_right),
                        color: AppTheme.primaryText,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: weekDays
                        .map((d) => Expanded(
                              child: Center(
                                child: Text(
                                  d,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: AppTheme.secondaryText,
                                  ),
                                ),
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 7,
                        childAspectRatio: 1.0,
                        crossAxisSpacing: 4,
                        mainAxisSpacing: 4,
                      ),
                      itemCount: daysInMonth + (firstWeekday - 1),
                      itemBuilder: (context, index) {
                        if (index < firstWeekday - 1) {
                          return const SizedBox.shrink();
                        }
                        final day = index - (firstWeekday - 2);
                        final date = DateTime(year, month, day);
                        final hasEvent = provider.hasEvents(date);
                        final isSelected = selectedDate != null &&
                            selectedDate!.year == date.year &&
                            selectedDate!.month == date.month &&
                            selectedDate!.day == date.day;
                        final isToday = now.year == date.year &&
                            now.month == date.month &&
                            now.day == date.day;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedDate = date;
                            });
                            provider.setSelectedDate(date);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? AppTheme.primary
                                  : isToday
                                      ? AppTheme.primary.withValues(alpha: 0.10)
                                      : Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: isToday && !isSelected
                                  ? Border.all(
                                      color: AppTheme.primary, width: 2)
                                  : null,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Text(
                                    '$day',
                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : AppTheme.primaryText,
                                      fontWeight: isToday || isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                                if (hasEvent && !isSelected)
                                  Positioned(
                                    bottom: 4,
                                    left: 0,
                                    right: 0,
                                    child: Center(
                                      child: Container(
                                        width: 4,
                                        height: 4,
                                        decoration: const BoxDecoration(
                                          color: AppTheme.primary,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: 1,
            color: Colors.grey.shade300,
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.white,
              child: selectedDate == null
                  ? const Center(
                      child: Text(
                        'Выберите день',
                        style: TextStyle(color: AppTheme.secondaryText),
                      ),
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            '${selectedDate!.day} ${_monthName(selectedDate!.month)}',
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ),
                        const Divider(height: 1),
                        Expanded(
                          child: provider.eventsForSelectedDate.isEmpty
                              ? const Center(
                                  child: Text(
                                    'Нет событий',
                                    style: TextStyle(
                                        color: AppTheme.secondaryText),
                                  ),
                                )
                              : ListView.builder(
                                  itemCount:
                                      provider.eventsForSelectedDate.length,
                                  itemBuilder: (context, index) {
                                    final e =
                                        provider.eventsForSelectedDate[index];
                                    return Dismissible(
                                      key: Key(e.id),
                                      direction: DismissDirection.endToStart,
                                      onDismissed: (_) =>
                                          provider.deleteEvent(e.id),
                                      background: Container(
                                        color: Colors.red,
                                        alignment: Alignment.centerRight,
                                        padding:
                                            const EdgeInsets.only(right: 16),
                                        child: const Icon(Icons.delete,
                                            color: Colors.white),
                                      ),
                                      child: ListTile(
                                        title: Text(e.title),
                                        subtitle: Text(
                                          e.description ?? '',
                                          style: const TextStyle(
                                              color: AppTheme.secondaryText),
                                        ),
                                        trailing: e.startTime != null
                                            ? Text(
                                                '${e.startTime!.hour}:${e.startTime!.minute.toString().padLeft(2, '0')}',
                                                style: const TextStyle(
                                                    color:
                                                        AppTheme.secondaryText),
                                              )
                                            : null,
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
        },
        child: const Icon(Icons.add),
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
      'Декабрь',
    ];
    return names[m - 1];
  }
}
