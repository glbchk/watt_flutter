class SlotModel {
  final String? timeSlot;
  final bool isBusy;

  SlotModel({
    this.timeSlot,
    this.isBusy = false,
  });

  factory SlotModel.fromJson(Map<String, dynamic> json) {
    return SlotModel(
      timeSlot: json['time_slot'],
      isBusy: json['is_busy'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'time_slot': timeSlot,
      'is_busy': isBusy,
    };
  }

  SlotModel copyWith({
    String? timeSlot,
    bool? isBusy,
  }) {
    return SlotModel(
      timeSlot: timeSlot ?? this.timeSlot,
      isBusy: isBusy ?? this.isBusy,
    );
  }
}
