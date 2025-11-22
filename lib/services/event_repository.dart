import '../models/event.dart';

/// Простая абстракция репозитория событий.
abstract class EventRepository {
  Future<List<Event>> getEventsForDate(DateTime date);
  Future<Event> createEvent(Event event);
  Future<void> deleteEvent(String id);

  /// Быстрая синхронная проверка наличия событий на дате (для индикаторов в календаре).
  bool hasEventsForDate(DateTime date);
}

/// In-memory реализация для быстрого старта.
class InMemoryEventRepository implements EventRepository {
  final List<Event> _events = <Event>[];

  @override
  Future<List<Event>> getEventsForDate(DateTime date) async {
    final y = date.year;
    final m = date.month;
    final d = date.day;
    return _events
        .where((e) => e.date.year == y && e.date.month == m && e.date.day == d)
        .toList();
  }

  @override
  Future<Event> createEvent(Event event) async {
    _events.add(event);
    return event;
  }

  @override
  Future<void> deleteEvent(String id) async {
    _events.removeWhere((e) => e.id == id);
  }

  @override
  bool hasEventsForDate(DateTime date) {
    final y = date.year;
    final m = date.month;
    final d = date.day;
    return _events.any(
      (e) => e.date.year == y && e.date.month == m && e.date.day == d,
    );
  }
}
