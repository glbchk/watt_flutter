import 'package:watt/data/models/mock_data_models.dart';

class KConstants {
  static const String themeModeKey = 'isDarkModeKey';
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

class KMockedData {
  static List<MockedCarOption> cars = [
    MockedCarOption('Audi', 'assets/car_logos/audi.png', MockedCarBrand.audi),
    MockedCarOption('BMW', 'assets/car_logos/bmw.png', MockedCarBrand.bmw),
    MockedCarOption(
      'Tesla',
      'assets/car_logos/tesla.png',
      MockedCarBrand.tesla,
    ),
    MockedCarOption(
      'Volvo',
      'assets/car_logos/volvo.png',
      MockedCarBrand.volvo,
    ),
    MockedCarOption(
      'Chevrolet',
      'assets/car_logos/chevrolet.png',
      MockedCarBrand.chevrolet,
    ),
    MockedCarOption(
      'Nissan',
      'assets/car_logos/nissan.png',
      MockedCarBrand.nissan,
    ),
  ];

  static List<MockedChargingStationOption> chargingStations = [
    MockedChargingStationOption('ABB', 'assets/charging_station_logos/abb.png'),
    MockedChargingStationOption(
      'Easee',
      'assets/charging_station_logos/easee.png',
    ),
    MockedChargingStationOption(
      'Garo',
      'assets/charging_station_logos/garo.png',
    ),
    MockedChargingStationOption(
      'Vattenfall',
      'assets/charging_station_logos/vattenfall.png',
    ),
    MockedChargingStationOption(
      'Tesla',
      'assets/charging_station_logos/tesla.png',
    ),
    MockedChargingStationOption(
      'Other',
      'assets/charging_station_logos/other_ev_station.png',
    ),
  ];

  static const Map<MockedCarBrand, List<String>> carModels = {
    MockedCarBrand.audi: [
      'Q4 e-tron',
      'Q4 Sportback e-tron',
      'Q6 e-tron',
      'Q6 Sportback e-tron',
      'Q8 e-tron',
      'Q8 Sportback e-tron',
      'e-tron GT',
      'RS e-tron GT',
    ],
    MockedCarBrand.bmw: [
      'i3',
      'i4',
      'i5',
      'i7',
      'iX1',
      'iX3',
      'iX',
    ],
    MockedCarBrand.tesla: [
      'Model S',
      'Model 3',
      'Model X',
      'Model Y',
      'Cybertruck',
    ],
    MockedCarBrand.volvo: [
      'EX30',
      'EX40',
      'EC40',
      'EX90',
    ],
    MockedCarBrand.chevrolet: [
      'Bolt EV',
      'Bolt EUV',
      'Blazer EV',
      'Equinox EV',
      'Silverado EV',
    ],
    MockedCarBrand.nissan: [
      'Leaf',
      'Ariya',
    ],
  };

  static List<String> chargingEffects = [
    '3,7 kW',
    '7,0 kW',
    '11,0 kW',
    '22,0 kW',
  ];

  static List<String> plugs = [
    '3-phase (CEE)',
    'Type 1',
    'Type 2',
    'Wall',
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

class KPaymentProvidersIcons {
  static const String amex = 'assets/payment_methods/ic_american_express.svg';
  static const String mastercard = 'assets/payment_methods/ic_mastercard.svg';
  static const String visa = 'assets/payment_methods/ic_visa.svg';
  static const String discover = 'assets/payment_methods/ic_discover.svg';
  static const String generic = 'assets/payment_methods/ic_generic.svg';
}
