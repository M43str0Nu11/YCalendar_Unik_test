import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/calendar.dart';

class CalendarProvider with ChangeNotifier {
  final List<CalendarModel> _calendars = [];
  String? _selectedCalendarId;
  final _uuid = const Uuid();

  CalendarProvider() {
    // Seed with one default calendar
    final defaultCal = CalendarModel(
      id: _uuid.v4(),
      name: 'Мои события',
      color: const Color(0xFFF44336), // red accent instead of blue
      isPrimary: true,
    );
    _calendars.add(defaultCal);
    _selectedCalendarId = defaultCal.id;
  }

  List<CalendarModel> get calendars => List.unmodifiable(_calendars);
  CalendarModel? get selectedCalendar =>
      _calendars.firstWhere((c) => c.id == _selectedCalendarId,
          orElse: () => _calendars.first);

  void selectCalendar(String id) {
    _selectedCalendarId = id;
    notifyListeners();
  }

  CalendarModel addCalendar({
    required String name,
    required Color color,
  }) {
    final model = CalendarModel(
      id: _uuid.v4(),
      name: name,
      color: color,
    );
    _calendars.add(model);
    notifyListeners();
    return model;
  }

  void updateCalendar(CalendarModel updated) {
    final idx = _calendars.indexWhere((c) => c.id == updated.id);
    if (idx != -1) {
      _calendars[idx] = updated;
      notifyListeners();
    }
  }

  void removeReminder(CalendarModel calendar, Reminder reminder) {
    final updated = calendar.copyWith(
      reminders: calendar.reminders.where((r) => r != reminder).toList(),
    );
    updateCalendar(updated);
  }

  void addReminder(CalendarModel calendar, Reminder reminder) {
    final updated = calendar.copyWith(
      reminders: [...calendar.reminders, reminder],
    );
    updateCalendar(updated);
  }
}
