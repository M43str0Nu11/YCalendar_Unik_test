import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/event.dart';
import '../services/event_repository.dart';

class EventProvider extends ChangeNotifier {
  final EventRepository repository;
  DateTime selectedDate = DateTime.now();
  List<Event> eventsForSelectedDate = <Event>[];

  EventProvider({EventRepository? repository})
    : repository = repository ?? InMemoryEventRepository() {
    loadForSelectedDate();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = DateTime(date.year, date.month, date.day);
    loadForSelectedDate();
  }

  Future<void> loadForSelectedDate() async {
    eventsForSelectedDate = await repository.getEventsForDate(selectedDate);
    notifyListeners();
  }

  Future<String> addEvent({
    required String title,
    DateTime? start,
    DateTime? end,
    String? description,
    DateTime? date,
  }) async {
    final id = const Uuid().v4();
    final eventDate = date ?? selectedDate;
    final event = Event(
      id: id,
      title: title,
      date: DateTime(eventDate.year, eventDate.month, eventDate.day),
      startTime: start,
      endTime: end,
      description: description,
    );
    await repository.createEvent(event);
    await loadForSelectedDate();
    return id;
  }

  Future<void> deleteEvent(String id) async {
    await repository.deleteEvent(id);
    await loadForSelectedDate();
  }

  bool hasEvents(DateTime date) => repository.hasEventsForDate(date);
}
