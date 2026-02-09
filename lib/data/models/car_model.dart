class CarModel {
  final String? brandName;
  final String? carModel;
  final String? plateNumber;

  CarModel({
    this.brandName,
    this.carModel,
    this.plateNumber,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      brandName: json['brand_name'],
      carModel: json['car_model'],
      plateNumber: json['plate_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'brand_name': brandName,
      'car_model': carModel,
      'plate_number': plateNumber,
    };
  }
}
