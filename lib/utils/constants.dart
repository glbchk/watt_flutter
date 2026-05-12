import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';

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

  static List<ChargingStationModel> mockedAddedByUsersChargingStations = [
    ChargingStationModel(
      type: ChargingStationType.private,
      id: '6f3b0e2a-1c8a-4d2b-9e4f-7a5b3c2d1e0f',
      chargingStationName: 'Alexander Karlsson’s charger',
      address: '103-610 Queen St, Saskatoon, SK S7K 0M8',
      addressLatitude: 52.13696,
      addressLongitude: -106.65239,
      chargingEffect: '11 kW',
      brandName: 'ABB',
      brandLogo: 'assets/charging_station_logos/abb.png',
      plug: 'Wall',
      pricePerKwh: '2.00',
      bankAccount: IbanModel(
        id: '6f3b0e2a-1c8a-4d2b-9e4f-7a5b3c2d1e0f',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'EB78573815158371807501',
      ),
      onlineCharger: true,
      availableHours: [
        TimeSlotModel(
          id: '1',
          availableDays: [2, 3],
          startTime: '10:00',
          endTime: '17:00',
        ),
      ],
      everyoneCanAccess: false,
      stationStatus: ChargingStationAvailability.available,
    ),
    ChargingStationModel(
      type: ChargingStationType.private,
      id: 'a8d1c5e9-3b7f-4a2c-8d1e-9f0a2b4c6e8d',
      chargingStationName: 'Peter’s Amp',
      address: '122 27 St W, Saskatoon, SK S7L 0J3',
      addressLatitude: 52.13555,
      addressLongitude: -106.67163,
      chargingEffect: '50 kW',
      brandName: 'Tesla',
      brandLogo: 'assets/charging_station_logos/tesla.png',
      plug: 'CCS',
      pricePerKwh: '5.50',
      bankAccount: IbanModel(
        id: 'a8d1c5e9-3b7f-4a2c-8d1e-9f0a2b4c6e8d',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE12345678901234567890',
      ),
      onlineCharger: true,
      availableHours: [
        TimeSlotModel(
          id: '2',
          availableDays: [1, 2, 3, 4, 5],
          startTime: '08:00',
          endTime: '20:00',
        ),
      ],
      everyoneCanAccess: true,
      stationStatus: ChargingStationAvailability.available,
    ),
    ChargingStationModel(
      type: ChargingStationType.private,
      id: '2c4e6a8b-0d2f-4c6e-8a0b-2d4f6a8b0d2f',
      chargingStationName: 'Södermalm Private Spot',
      address: '310 Circle Dr, Saskatoon, SK S7L 2Y5',
      addressLatitude: 52.15903,
      addressLongitude: -106.67410,
      chargingEffect: '7 kW',
      brandName: 'Easee',
      brandLogo: 'assets/charging_station_logos/easee.png',
      plug: 'Type 2',
      pricePerKwh: '3.25',
      bankAccount: IbanModel(
        id: '2c4e6a8b-0d2f-4c6e-8a0b-2d4f6a8b0d2f',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE98765432109876543210',
      ),
      onlineCharger: true,
      availableHours: [],
      everyoneCanAccess: false,
      stationStatus: ChargingStationAvailability.outOfService,
    ),
    ChargingStationModel(
      type: ChargingStationType.private,
      id: 'f1a3c5e7-9b2d-4f6a-8c0e-2a4d6f8b0c2e',
      chargingStationName: 'Solna Business Park',
      address: '1937 Ontario Ave, Saskatoon, SK S7K 1T5',
      addressLatitude: 52.15604,
      addressLongitude: -106.66654,
      chargingEffect: '22 kW',
      brandName: 'Garo',
      brandLogo: 'assets/charging_station_logos/garo.png',
      plug: 'Type 2',
      pricePerKwh: '4.00',
      bankAccount: IbanModel(
        id: 'f1a3c5e7-9b2d-4f6a-8c0e-2a4d6f8b0c2e',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE55443322110099887766',
      ),
      onlineCharger: true,
      availableHours: [
        TimeSlotModel(
          id: '4',
          availableDays: [1, 2, 3, 4, 5],
          startTime: '09:00',
          endTime: '09:30',
        ),
      ],
      everyoneCanAccess: true,
      stationStatus: ChargingStationAvailability.available,
    ),
    ChargingStationModel(
      type: ChargingStationType.private,
      id: '9e7a6c5b-4d3f-2a1e-8c0b-6f8a0d2c4e6f',
      chargingStationName: 'Lidingö Home Connect',
      address: '16 33 St E, Saskatoon, SK S7L 1C3',
      addressLatitude: 52.14420,
      addressLongitude: -106.66932,
      chargingEffect: '11 kW',
      brandName: 'Wallbox',
      brandLogo: 'assets/charging_station_logos/wallbox.png',
      plug: 'Wall',
      pricePerKwh: '2.50',
      bankAccount: IbanModel(
        id: '9e7a6c5b-4d3f-2a1e-8c0b-6f8a0d2c4e6f',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE11223344556677889900',
      ),
      onlineCharger: false,
      availableHours: [
        TimeSlotModel(
          id: '5',
          availableDays: [1, 3, 5],
          startTime: '18:00',
          endTime: '20:00',
        ),
      ],
      everyoneCanAccess: false,
      stationStatus: ChargingStationAvailability.outOfService,
    ),
    ChargingStationModel(
      type: ChargingStationType.private,
      id: '3a5c7e9b-1d2f-4a6c-8b0e-2d4f6a8b0c2e',
      chargingStationName: 'Östermalm Boutique Charge',
      address: '1527A Idylwyld Dr N, Saskatoon, SK S7L 1A9',
      addressLatitude: 52.14991,
      addressLongitude: -106.67077,
      chargingEffect: '11 kW',
      brandName: 'Zaptec',
      brandLogo: 'assets/charging_station_logos/zaptec.png',
      plug: 'Type 2',
      pricePerKwh: '6.00',
      bankAccount: IbanModel(
        id: '3a5c7e9b-1d2f-4a6c-8b0e-2d4f6a8b0c2e',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE99887766554433221100',
      ),
      onlineCharger: true,
      availableHours: [
        TimeSlotModel(
          id: '6',
          availableDays: [1, 2, 3, 4, 5, 6, 7],
          startTime: '00:00',
          endTime: '23:59',
        ),
      ],
      everyoneCanAccess: true,
      stationStatus: ChargingStationAvailability.available,
    ),
  ];

  static List<ChargingStationModel> mockedPublicChargingStations = [
    ChargingStationModel(
      type: ChargingStationType.public,
      id: '7a6c5b4d-3f2e-1a0b-8c0d-6f8a0d2c4e6f',
      chargingStationName: 'Starbucks',
      address: '536 2nd Ave N #120, Saskatoon, SK S7K 2C5',
      addressLatitude: 52.13656,
      addressLongitude: -106.65972,
      chargingEffect: '11 kW',
      brandName: 'ABB',
      brandLogo: 'assets/charging_station_logos/abb.png',
      plug: 'Wall',
      pricePerKwh: '2.00',
      bankAccount: IbanModel(
        id: '7a6c5b4d-3f2e-1a0b-8c0d-6f8a0d2c4e6f',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'EB78573815158371807501',
      ),
      onlineCharger: true,
      everyoneCanAccess: false,
      stationStatus: ChargingStationAvailability.available,
    ),
    ChargingStationModel(
      type: ChargingStationType.public,
      id: '8b0e1a2c-4d3f-5a6c-7b8d-9f0a1b2c3d4e',
      chargingStationName: "Mc'Donalds",
      address: '714 2nd Ave N, Saskatoon, SK S7K 2E1',
      addressLatitude: 52.13849,
      addressLongitude: -106.65882,
      chargingEffect: '50 kW',
      brandName: 'Tesla',
      brandLogo: 'assets/charging_station_logos/tesla.png',
      plug: 'CCS',
      pricePerKwh: '5.50',
      bankAccount: IbanModel(
        id: '8b0e1a2c-4d3f-5a6c-7b8d-9f0a1b2c3d4e',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE12345678901234567890',
      ),
      onlineCharger: true,
      everyoneCanAccess: true,
      stationStatus: ChargingStationAvailability.available,
    ),
    ChargingStationModel(
      type: ChargingStationType.public,
      id: '9c1d2e3f-4a5b-6c7d-8e9f-0a1b2c3d4e5f',
      chargingStationName: 'Government Spot 1',
      address: '2115 Faithfull Ave, Saskatoon, SK S7K 1T8',
      addressLatitude: 52.15903,
      addressLongitude: -106.66613,
      chargingEffect: '7 kW',
      brandName: 'Easee',
      brandLogo: 'assets/charging_station_logos/easee.png',
      plug: 'Type 2',
      pricePerKwh: '3.25',
      bankAccount: IbanModel(
        id: '9c1d2e3f-4a5b-6c7d-8e9f-0a1b2c3d4e5f',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE98765432109876543210',
      ),
      onlineCharger: true,
      everyoneCanAccess: false,
      stationStatus: ChargingStationAvailability.outOfService,
    ),
    ChargingStationModel(
      type: ChargingStationType.public,
      id: '0d2e3f4a-5b6c-7d8e-9f0a-1b2c3d4e5f6a',
      chargingStationName: 'Hospital',
      address: '701 Queen St, Saskatoon, SK S7K 0M7',
      addressLatitude: 52.13590,
      addressLongitude: -106.65354,
      chargingEffect: '22 kW',
      brandName: 'Garo',
      brandLogo: 'assets/charging_station_logos/garo.png',
      plug: 'Type 2',
      pricePerKwh: '4.00',
      bankAccount: IbanModel(
        id: '0d2e3f4a-5b6c-7d8e-9f0a-1b2c3d4e5f6a',
        isUsedForReceivingEarnings: true,
        ibanNumber: 'SE55443322110099887766',
      ),
      onlineCharger: true,
      everyoneCanAccess: true,
      stationStatus: ChargingStationAvailability.available,
    ),
  ];

  static List<MockedFaq> faqContent = [
    MockedFaq(
      'What is Watt and how does it work?',
      'Watt helps you find nearby EV charging stations quickly and easily. Open the app, allow location access, and you’ll see available stations around you. You can view details like location, availability, and directions—all in one place.',
    ),
    MockedFaq(
      'Do I need an account to use the app?',
      'You can browse charging stations without an account. However, creating an account allows you to save favorites, track your activity, and access personalized features like sharing and recommendations.',
    ),
    MockedFaq(
      'How accurate is the charging station information?',
      'We strive to keep all station data as accurate and up to date as possible. Information is sourced from trusted providers and regularly updated. However, availability may occasionally change in real time, so it’s always a good idea to double-check before heading out.',
    ),
    MockedFaq(
      'Can I share charging stations with friends?',
      'Yes. You can easily share stations or invite friends using the built-in share feature. Just tap the share button, and choose your preferred app to send the link.',
    ),
    MockedFaq(
      'Does Watt work on both Android and iOS?',
      'Yes, Watt is fully supported on both Android and iOS devices. The experience is designed to be consistent across platforms.',
    ),
    MockedFaq(
      'Why do I need to enable location services?',
      'Location access allows the app to show charging stations near you and provide accurate directions. Without it, you can still search manually, but results may be less convenient.',
    ),
    MockedFaq(
      'Is Watt free to use?',
      'Yes, Watt is free to download and use. Some features may expand in the future, but the core functionality of finding and viewing charging stations will remain accessible.',
    ),
  ];
}

class KPaymentProvidersIcons {
  static const String amex = 'assets/payment_methods/ic_american_express.svg';
  static const String mastercard = 'assets/payment_methods/ic_mastercard.svg';
  static const String visa = 'assets/payment_methods/ic_visa.svg';
  static const String discover = 'assets/payment_methods/ic_discover.svg';
  static const String generic = 'assets/payment_methods/ic_generic.svg';
}

class KCreditCardBG {
  static const String amex = 'assets/credit_card_bg/ocean_blue.png';
  static const String mastercard = 'assets/credit_card_bg/peach_orange.png';
  static const String visa = 'assets/credit_card_bg/dark_crystal.png';
  static const String discover = 'assets/credit_card_bg/hot_ion.png';
  static const String generic = 'assets/credit_card_bg/rosey_rose.png';
}
