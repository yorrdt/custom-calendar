const String tableSchedule = 'schedule_app';

class ScheduleFields {
  static final List<String> values = [
    // Add values
    id, title, createdTime
  ];

  static const String id = '_id';
  static const String title = 'title';
  static const String createdTime = 'createdTime';
}

class Schedule {
  final int? id;
  final String title;
  final DateTime createdTime;

  const Schedule({
    this.id,
    required this.title,
    required this.createdTime,
  });

  Schedule copy({
    int? id,
    String? title,
    DateTime? createdTime,
  }) {
    return Schedule(
      id: id ?? this.id,
      title: title ?? this.title,
      createdTime: createdTime ?? this.createdTime,
    );
  }

  static Schedule fromJson(Map<String, Object?> json) {
    return Schedule(
      id: json[ScheduleFields.id] as int?,
      title: json[ScheduleFields.title] as String,
      createdTime: DateTime.parse(json[ScheduleFields.createdTime] as String),
    );
  }

  Map<String, Object?> toJson() {
    return {
      ScheduleFields.id: id,
      ScheduleFields.title: title,
      ScheduleFields.createdTime: createdTime.toIso8601String(),
    };
  }
}
