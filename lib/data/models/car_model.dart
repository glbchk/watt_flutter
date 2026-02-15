class CarModel {
  final String id;
  final String? brandLogo;
  final String? brandName;
  final String? carModel;
  final String? plateNumber;

  CarModel({
    required this.id,
    this.brandLogo,
    this.brandName,
    this.carModel,
    this.plateNumber,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      brandLogo: json['brand_logo'],
      brandName: json['brand_name'],
      carModel: json['car_model'],
      plateNumber: json['plate_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand_logo': brandLogo,
      'brand_name': brandName,
      'car_model': carModel,
      'plate_number': plateNumber,
    };
  }

  CarModel copyCarWith({
    String? id,
    String? brandLogo,
    String? brandName,
    String? carModel,
    String? plateNumber,
  }) {
    return CarModel(
      id: id ?? this.id,
      brandLogo: brandLogo ?? this.brandLogo,
      brandName: brandName ?? this.brandName,
      carModel: carModel ?? this.carModel,
      plateNumber: plateNumber ?? this.plateNumber,
    );
  }
}
