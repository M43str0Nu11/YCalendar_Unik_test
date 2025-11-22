class Event {
  final String id;
  final String title;
  final DateTime date;
  final DateTime? startTime;
  final DateTime? endTime;
  final String? description;

  Event({
    required this.id,
    required this.title,
    required this.date,
    this.startTime,
    this.endTime,
    this.description,
  });

  Event copyWith({
    String? id,
    String? title,
    DateTime? date,
    DateTime? startTime,
    DateTime? endTime,
    String? description,
  }) {
    return Event(
      id: id ?? this.id,
      title: title ?? this.title,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      description: description ?? this.description,
    );
  }

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      title: json['title'] as String,
      date: DateTime.parse(json['date'] as String),
      startTime: json['start_time'] != null
          ? DateTime.parse(json['start_time'] as String)
          : null,
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      description: json['description'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'date': date.toIso8601String(),
    'start_time': startTime?.toIso8601String(),
    'end_time': endTime?.toIso8601String(),
    'description': description,
  };
}
