class TimeSlotModel {
  final String id;
  final List<int>? availableDays;
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
      availableDays: json['available_days'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'available_days': availableDays,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  TimeSlotModel copyWith({
    String? id,
    List<int>? availableDays,
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
