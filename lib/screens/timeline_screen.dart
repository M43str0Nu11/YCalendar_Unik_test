import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/event_provider.dart';
import '../models/event.dart';
import '../providers/calendar_provider.dart';
import '../theme/app_theme.dart';
import 'calendar_screen.dart';
import 'calendars_sheet.dart';
import 'create_event_screen.dart';
import 'month_overlay.dart';
import 'event_details_sheet.dart';
import 'profile_screen.dart';

class TimelineScreen extends StatelessWidget {
  const TimelineScreen({super.key});

  static const double hourHeight = 60; // px per hour

  String _monthName(int m) {
    const months = [
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
    return months[m - 1];
  }

  @override
  Widget build(BuildContext context) {
    final eventProvider = Provider.of<EventProvider>(context);
    final calendarProvider = Provider.of<CalendarProvider>(context);
    final date = eventProvider.selectedDate;
    final events = eventProvider.eventsForSelectedDate;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.chevron_left),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) => const MonthOverlay(),
            );
          },
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) => const MonthOverlay(),
                );
              },
              child: Text(_monthName(date.month),
                  style: Theme.of(context).textTheme.titleLarge),
            ),
            const SizedBox(width: 8),
            Text('${date.year}', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            icon: _CalendarsIcon(),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (_) => const CalendarsSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Поиск пока не реализован')),
              );
            },
          ),
        ],
      ),
      body: _DayEventsBody(
        date: date,
        events: events,
        calendarColor: calendarProvider.selectedCalendar?.color ??
            Theme.of(context).colorScheme.primary,
      ),
      floatingActionButton: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const CreateEventScreen()),
          );
        },
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.35),
                offset: const Offset(0, 4),
                blurRadius: 10,
                spreadRadius: 0,
              ),
            ],
          ),
          child: const Center(
              child: Icon(Icons.add, color: Colors.white, size: 30)),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _BottomBar(onMonthTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const CalendarScreen()),
        );
      }),
    );
  }
}

class _DayEventsBody extends StatelessWidget {
  final DateTime date;
  final List<Event> events;
  final Color calendarColor;
  const _DayEventsBody({
    required this.date,
    required this.events,
    required this.calendarColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F6F8),
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        children: [
          Text(
            _dateHeading(date),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          ...events
              .map((e) => _EventCard(event: e, color: calendarColor))
              .toList(),
        ],
      ),
    );
  }

  String _dateHeading(DateTime d) {
    final months = [
      'января',
      'февраля',
      'марта',
      'апреля',
      'мая',
      'июня',
      'июля',
      'августа',
      'сентября',
      'октября',
      'ноября',
      'декабря'
    ];
    final today = DateTime.now();
    final isToday =
        today.year == d.year && today.month == d.month && today.day == d.day;
    return '${d.day} ${months[d.month - 1]}, ${isToday ? 'сегодня' : ''}'
        .trim();
  }
}

class _EventCard extends StatelessWidget {
  final Event event;
  final Color color;
  const _EventCard({required this.event, required this.color});

  @override
  Widget build(BuildContext context) {
    final start = event.startTime;
    final end = event.endTime;
    final timeRange = (start != null && end != null)
        ? '${_pad(start.hour)}:${_pad(start.minute)} - ${_pad(end.hour)}:${_pad(end.minute)}'
        : '';
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
          context: context,
          builder: (_) => EventDetailsSheet(event: event),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 6,
              height: 72,
              decoration: BoxDecoration(
                color: color,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(18),
                  bottomLeft: Radius.circular(18),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(timeRange,
                        style: const TextStyle(
                            color: Colors.black87,
                            fontSize: 14,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 6),
                    Text(
                      event.title.isEmpty ? 'Без названия' : event.title,
                      style: const TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _pad(int v) => v.toString().padLeft(2, '0');
}

class _BottomBar extends StatelessWidget {
  final VoidCallback onMonthTap;
  const _BottomBar({required this.onMonthTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppTheme.border)),
      ),
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.calendar_month_outlined),
            onPressed: onMonthTap,
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey.shade800,
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.accentBlueRing, width: 2),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CalendarsIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 28,
      height: 28,
      child: GridView.count(
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 2,
        crossAxisSpacing: 2,
        children: const [
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFF44336), // red accent
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFD3D3), // light pink
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFF7A23),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Color(0xFFFFB300),
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
          ),
        ],
      ),
    );
  }
}
