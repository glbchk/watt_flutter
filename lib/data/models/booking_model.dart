import 'package:watt/data/models/slot_model.dart';

enum BookingStatus {
  available,
  pending,
  confirmed,
  charging,
  cancelled,
}

class BookingModel {
  final String id;
  final BookingStatus status;
  final String? stationId;
  final String? date;
  final List<SlotModel>? selectedTimes;
  final double? energyAmount;
  final double? price;
  final String? cardNumber;

  BookingModel({
    required this.id,
    this.status = BookingStatus.pending,
    this.stationId,
    this.date,
    this.selectedTimes,
    this.energyAmount,
    this.price,
    this.cardNumber,
  });

  factory BookingModel.fromJson(Map<String, dynamic> json) {
    return BookingModel(
      id: json['id'],
      status: BookingStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => BookingStatus.available,
      ),
      stationId: json['station_id'],
      date: json['date'],
      selectedTimes: (json['selected_times'] as List<dynamic>?)
          ?.map((m) => SlotModel.fromJson(m))
          .toList(),
      energyAmount: json['energy_amount'],
      price: json['price'],
      cardNumber: json['card_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'status': status.name,
      'station_id': stationId,
      'date': date,
      'selected_times': selectedTimes?.map((m) => m.toJson()).toList(),
      'energy_amount': energyAmount,
      'price': price,
      'card_number': cardNumber,
    };
  }

  BookingModel copyWith({
    String? id,
    BookingStatus? status,
    String? stationId,
    String? date,
    List<SlotModel>? selectedTimes,
    double? energyAmount,
    double? price,
    String? cardNumber,
  }) {
    return BookingModel(
      id: id ?? this.id,
      status: status ?? this.status,
      stationId: stationId ?? this.stationId,
      date: date ?? this.date,
      selectedTimes: selectedTimes ?? this.selectedTimes,
      energyAmount: energyAmount ?? this.energyAmount,
      price: price ?? this.price,
      cardNumber: cardNumber ?? this.cardNumber,
    );
  }
}
