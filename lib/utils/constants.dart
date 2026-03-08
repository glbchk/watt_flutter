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
  static const String profile = 'assets/icons/profile.svg';
  static const String car = 'assets/icons/car.svg';
  static const String chargingStation = 'assets/icons/charging_station.svg';
  static const String paymentMethod = 'assets/icons/credit_card.svg';
  static const String timeSlot = 'assets/icons/time_slot.svg';
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

class KChargingStation {
  static List<String> chargingStationList = [
    KChargingStationsNames.abb,
    KChargingStationsNames.easee,
    KChargingStationsNames.garo,
    KChargingStationsNames.vattenfall,
    KChargingStationsNames.tesla,
    KChargingStationsNames.other,
  ];

  static List<String> chargingStationIconsList = [
    KChargingStationsLogos.abb,
    KChargingStationsLogos.easee,
    KChargingStationsLogos.garo,
    KChargingStationsLogos.vattenfall,
    KChargingStationsLogos.tesla,
    KChargingStationsLogos.other,
  ];

  static List<String> chargingEffectList = [
    KChargingEffect.three,
    KChargingEffect.seven,
    KChargingEffect.eleven,
    KChargingEffect.twentyTwo,
  ];

  static List<String> plugList = [
    KPlugs.threePhase,
    KPlugs.typeOne,
    KPlugs.typeTwo,
    KPlugs.wall,
  ];

  static const Map<int, String> daysList = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };
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

class KChargingEffect {
  static const String three = '3,7 kW';
  static const String seven = '7,0 kW';
  static const String eleven = '11,0 kW';
  static const String twentyTwo = '22,0 kW';
}

class KPlugs {
  static const String threePhase = '3-phase (CEE)';
  static const String typeOne = 'Type 1';
  static const String typeTwo = 'Type 2';
  static const String wall = 'Wall';
}

class KPaymentProvidersIcons {
  static const String amex = 'assets/payment_methods/ic_american_express.svg';
  static const String mastercard = 'assets/payment_methods/ic_mastercard.svg';
  static const String visa = 'assets/payment_methods/ic_visa.svg';
  static const String discover = 'assets/payment_methods/ic_discover.svg';
  static const String generic = 'assets/payment_methods/ic_generic.svg';
}
