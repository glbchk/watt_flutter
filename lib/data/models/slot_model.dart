class SlotModel {
  final String id;
  final String? dayStamp;
  final String? startTime;
  final String? endTime;
  final bool isBusy;

  SlotModel({
    required this.id,
    this.dayStamp,
    this.startTime,
    this.endTime,
    this.isBusy = false,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      id: json['id'],
      dayStamp: json['day_stamp'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      isBusy: json['is_busy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'day_stamp': dayStamp,
      'start_time': startTime,
      'end_time': endTime,
      'is_busy': isBusy,
    };
  }

  SlotModel copyWith({
    String? id,
    String? dayStamp,
    String? startTime,
    String? endTime,
    bool? isBusy,
  }) {
    return SlotModel(
      id: id ?? this.id,
      dayStamp: dayStamp ?? this.dayStamp,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
