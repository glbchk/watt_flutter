enum WeekDays {
  monday('M'),
  tuesday('T'),
  wednesday('W'),
  thursday('T'),
  friday('F'),
  saturday('S'),
  sunday('S')
  ;

  final String value;

  const WeekDays(this.value);
}

class TimeSlotModel {
  final String id;
  final List<WeekDays>? availableDays;
  final String? startTime;
  final String? endTime;

  TimeSlotModel({
    required this.id,
    this.availableDays,
    this.startTime,
    this.endTime,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      id: json['id'],
      availableDays: (json['available_days'] as List<dynamic>?)
          ?.map((m) => WeekDays.values.byName(m))
          .toList(),
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'available_days': availableDays?.map((m) => m.name).toList(),
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  TimeSlotModel copyWith({
    String? id,
    List<WeekDays>? availableDays,
    String? startTime,
    String? endTime,
  }) {
    return TimeSlotModel(
      id: id ?? this.id,
      availableDays: availableDays ?? this.availableDays,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
