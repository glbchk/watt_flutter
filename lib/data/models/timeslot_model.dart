class TimeSlotModel {
  final List<String>? availableDays;
  final String? startTime;
  final String? endTime;

  TimeSlotModel({
    this.availableDays,
    this.startTime,
    this.endTime,
  });

  factory TimeSlotModel.fromJson(Map<String, dynamic> json) {
    return TimeSlotModel(
      availableDays: json['available_days'],
      startTime: json['start_time'],
      endTime: json['end_time'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'available_days': availableDays,
      'start_time': startTime,
      'end_time': endTime,
    };
  }
}
