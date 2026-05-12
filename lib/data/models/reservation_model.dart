import 'package:watt/data/models/slot_model.dart';

enum ReservationStatus {
  available,
  pending,
  confirmed,
  charging,
  cancelled,
}

class ReservationModel {
  final String id;
  final ReservationStatus status;
  final String? stationId;
  final String? date;
  final List<SlotModel>? selectedTimes;
  final double? energyAmount;
  final double? price;
  final String? cardNumber;

  ReservationModel({
    required this.id,
    this.status = ReservationStatus.pending,
    this.stationId,
    this.date,
    this.selectedTimes,
    this.energyAmount,
    this.price,
    this.cardNumber,
  });

  factory ReservationModel.fromJson(Map<String, dynamic> json) {
    return ReservationModel(
      id: json['id'],
      status: ReservationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ReservationStatus.available,
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

  ReservationModel copyWith({
    String? id,
    ReservationStatus? status,
    String? stationId,
    String? date,
    List<SlotModel>? selectedTimes,
    double? energyAmount,
    double? price,
    String? cardNumber,
  }) {
    return ReservationModel(
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
