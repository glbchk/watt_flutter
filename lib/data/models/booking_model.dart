import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/timeslot_model.dart';

enum BookingStatus {
  available,
  pending,
  confirmed,
  charging,
  cancelled,
}

class BookingModel {
  final String bookingId;
  final BookingStatus status;
  final ChargingStationModel? station;
  final String? date;
  final List<TimeSlotModel>? selectedTimes;
  final double? price;

  BookingModel({
    required this.bookingId,
    this.status = BookingStatus.pending,
    this.station,
    this.date,
    this.selectedTimes,
    this.price,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      bookingId: json['id'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.available,
      ),
      station: json['station'] != null
          ? ChargingStationModel.fromJson(
              json['station'] as Map<String, dynamic>,
            )
          : null,
      date: json['date'],
      selectedTimes:
          (json['selected_time'] as List<dynamic>?)
              ?.map(
                (item) => TimeSlotModel.fromJson(item as Map<String, dynamic>),
              )
              .toList() ??
          [],
      price: json['price'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': bookingId,
      'status': status.name,
      'station': station?.toJson(),
      'date': date,
      'selected_time':
          selectedTimes?.map((item) => item.toJson()).toList() ?? [],
      'price': price,
    };
  }

  BookingModel copyWith({
    String? bookingId,
    BookingStatus? status,
    ChargingStationModel? station,
    String? date,
    List<TimeSlotModel>? selectedTime,
    double? price,
  }) {
    return BookingModel(
      bookingId: bookingId ?? this.bookingId,
      status: status ?? this.status,
      station: station ?? this.station,
      date: date ?? this.date,
      selectedTimes: selectedTime ?? this.selectedTimes,
      price: price ?? this.price,
    );
  }
}
