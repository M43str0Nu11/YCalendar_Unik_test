import 'package:flutter/material.dart';

class Reminder {
  final int value; // numeric value (e.g. 15)
  final ReminderUnit unit; // minutes/hours/days/weeks or immediate
  final ReminderChannel channel; // push/email/caldav/browser

  const Reminder({
    required this.value,
    required this.unit,
    required this.channel,
  });
}

enum ReminderUnit { moment, minutes, hours, days, weeks }

enum ReminderChannel { pushApp, email, caldav, pushBrowser }

class CalendarModel {
  final String id;
  String name;
  Color color;
  CalendarVisibility visibility;
  int defaultMeetingMinutes; // e.g. 30
  bool notifyUnaccepted; // toggle red switch
  bool isPrimary;
  final List<Reminder> reminders;

  CalendarModel({
    required this.id,
    required this.name,
    required this.color,
    this.visibility = CalendarVisibility.participants,
    this.defaultMeetingMinutes = 30,
    this.notifyUnaccepted = false,
    this.isPrimary = false,
    List<Reminder>? reminders,
  }) : reminders = reminders ?? [];

  CalendarModel copyWith({
    String? name,
    Color? color,
    CalendarVisibility? visibility,
    int? defaultMeetingMinutes,
    bool? notifyUnaccepted,
    bool? isPrimary,
    List<Reminder>? reminders,
  }) {
    return CalendarModel(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      visibility: visibility ?? this.visibility,
      defaultMeetingMinutes:
          defaultMeetingMinutes ?? this.defaultMeetingMinutes,
      notifyUnaccepted: notifyUnaccepted ?? this.notifyUnaccepted,
      isPrimary: isPrimary ?? this.isPrimary,
      reminders: reminders ?? this.reminders,
    );
  }
}

enum CalendarVisibility { participants, everyone }
