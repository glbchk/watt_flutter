import 'package:flutter/material.dart';

class KConstants {
  static const String themeModeKey = 'isDarkModeKey';
}

class AppColors {
  static const Color primaryColor = Color(0xFF1581FF);
  // static const Color secondaryBrand = Color(0xFF444FAB);
  // static const Color errorColor = Color(0xFFB00020);
}

class KCardTitles {
  static const String addNameAndPhoneNumber = 'Add your name & email';
  static const String addCar = 'Add your car';
  static const String addChargingStation = 'Add your charger station';
  static const String addPaymentMethod = 'Add payment method';
}

class KCardIcons {
  static const IconData profile = Icons.account_circle_outlined;
  static const IconData car = Icons.directions_car_outlined;
  static const IconData chargingStation = Icons.ev_station_outlined;
  static const IconData paymentMethod = Icons.credit_card;
}

class KCarNames {
  static const String audi = 'Audi';
  static const String bmw = 'BMW';
  static const String tesla = 'Tesla';
  static const String volvo = 'Volvo';
  static const String chevrolet = 'Chevrolet';
  static const String nissan = 'Nissan';
}

class KCarLogos {
  static const String audi = 'assets/car_logos/audi.png';
  static const String bmw = 'assets/car_logos/bmw.png';
  static const String tesla = 'assets/car_logos/tesla.png';
  static const String volvo = 'assets/car_logos/volvo.png';
  static const String chevrolet = 'assets/car_logos/chevrolet.png';
  static const String nissan = 'assets/car_logos/nissan.png';
}

class KChargingStationsNames {
  static const String abb = 'ABB';
  static const String easee = 'Easee';
  static const String garo = 'Garo';
  static const String vattenfall = 'Vattenfall';
  static const String tesla = 'Tesla';
  static const String other = 'Other';
}

class KChargingStationsLogos {
  static const String abb = 'assets/charging_station_logos/abb.png';
  static const String easee = 'assets/charging_station_logos/easee.png';
  static const String garo = 'assets/charging_station_logos/garo.png';
  static const String vattenfall =
      'assets/charging_station_logos/vattenfall.png';
  static const String tesla = 'assets/charging_station_logos/tesla.png';
  static const String other =
      'assets/charging_station_logos/other_ev_station.png';
}
