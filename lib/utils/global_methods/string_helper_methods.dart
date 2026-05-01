import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/slot_model.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/utils/constants.dart';

class StringHelperMethods {
  static String? validateMinLength({
    required String value,
    required int minLength,
    required String errorMessage,
  }) {
    print(value.length);
    if (value.isEmpty) return null;
    if (value.length < minLength) return errorMessage;
    return null;
  }

  static String? createNameAndPhoneLabel(String? name, String? phoneNumber) {
    if (name != null && phoneNumber != null) return '$name, $phoneNumber';
    if (name != null) return name;
    if (phoneNumber != null) return phoneNumber;
    return null;
  }

  static String? createChargingStationLabel(
    String? brandName,
    String? chargingEffect,
    String? plug,
  ) {
    if (brandName != null && chargingEffect != null && plug != null) {
      return '$brandName, $chargingEffect, $plug';
    }
    return null;
  }

  static String _formatRange(int start, int end) {
    if (start == end) {
      return KMockedData.daysList[start] ?? '';
    }

    return '${KMockedData.daysList[start]}-${KMockedData.daysList[end]}';
  }

  static String formatDayRanges(List<int>? chosenDays) {
    if (chosenDays == null || chosenDays.isEmpty) {
      return '';
    }

    final sortedDays = List<int>.from(chosenDays)..sort();

    if (sortedDays.isEmpty) return '';

    List<String> groups = [];

    int start = sortedDays.first;
    int last = sortedDays.last;

    groups.add(_formatRange(start, last));

    return groups.join(' - ');
  }

  static String getCardType(String cardNumber) {
    String cleanNumber = cardNumber.replaceAll(' ', '');

    if (cleanNumber.isEmpty) return 'unknown';

    if (cleanNumber.startsWith('4')) return 'visa';

    if (RegExp(r'^5[1-5]').hasMatch(cleanNumber) ||
        RegExp(
          r'^2(22[1-9]|2[3-9][0-9]|[3-6][0-9]{2}|7[01][0-9]|720)',
        ).hasMatch(cleanNumber)) {
      return 'mastercard';
    }

    if (RegExp(r'^3[47]').hasMatch(cleanNumber)) return 'amex';

    if (cleanNumber.startsWith('65')) return 'discover';

    return 'unknown';
  }

  static String getNetworkLogoAssetPath(String cardType) {
    switch (cardType) {
      case 'visa':
        return KPaymentProvidersIcons.visa;
      case 'mastercard':
        return KPaymentProvidersIcons.mastercard;
      case 'amex':
        return KPaymentProvidersIcons.amex;
      case 'discover':
        return KPaymentProvidersIcons.discover;
      default:
        return KPaymentProvidersIcons.generic;
    }
  }

  static String getCreditCardBGAssetPath(String cardType) {
    switch (cardType) {
      case 'visa':
        return KCreditCardBG.visa;
      case 'mastercard':
        return KCreditCardBG.mastercard;
      case 'amex':
        return KCreditCardBG.amex;
      case 'discover':
        return KCreditCardBG.discover;
      default:
        return KCreditCardBG.generic;
    }
  }

  static String getBGAssetPath(String cardType) {
    switch (cardType) {
      case 'visa':
        return KCreditCardBG.visa;
      case 'mastercard':
        return KPaymentProvidersIcons.mastercard;
      case 'amex':
        return KPaymentProvidersIcons.amex;
      case 'discover':
        return KPaymentProvidersIcons.discover;
      default:
        return KPaymentProvidersIcons.generic;
    }
  }

  static List<SlotModel> generate30MinuteSlots(
    TimeSlotModel availability,
  ) {
    List<SlotModel> slots = [];

    final DateFormat formatter = DateFormat('HH:mm');
    final DateTime now = DateTime.now();

    try {
      DateTime start = formatter.parse(availability.startTime ?? '');
      DateTime end = formatter.parse(availability.endTime ?? '');

      DateTime currentSlot = DateTime(
        now.year,
        now.month,
        now.day,
        start.hour,
        start.minute,
      );
      DateTime endDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        end.hour,
        end.minute,
      );

      if (endDateTime.isBefore(currentSlot) ||
          endDateTime.isAtSameMomentAs(currentSlot)) {
        endDateTime = endDateTime.add(const Duration(days: 1));
      }

      while (currentSlot.isBefore(endDateTime)) {
        DateTime nextSlot = currentSlot.add(const Duration(minutes: 30));

        if (nextSlot.isAfter(endDateTime)) break;

        slots.add(
          SlotModel(
            id: Uuid().v4(),
            startTime: formatter.format(currentSlot),
            endTime: formatter.format(nextSlot),
            isBusy: false,
          ),
        );

        currentSlot = nextSlot;
      }
    } catch (e) {
      print("Error parsing times: $e");
    }

    return slots;
  }

  static String? convertToOneSlot(List<SlotModel> slots) {
    if (slots.isEmpty) {
      return 'No time slots exist';
    } else {
      List<String?> startTimes = slots.map((s) => s.startTime).toList();
      List<String?> endTimes = slots.map((s) => s.endTime).toList();

      startTimes.sort();
      endTimes.sort();

      final earliestStart = startTimes.first;
      final latestEnd = endTimes.last;

      return '$earliestStart - $latestEnd';
    }
  }

  static String? convertToStartTime(String date, List<SlotModel> slots) {
    if (slots.isEmpty) {
      return 'No time slots exist';
    } else {
      List<String?> startTimes = slots.map((s) => s.startTime).toList();

      startTimes.sort();
      final formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(date));

      final earliestStart = '$formattedDate, ${startTimes.first}';
      print('Earliest start time: $earliestStart');

      return earliestStart;
    }
  }

  static String? convertToEndTime(String date, List<SlotModel> slots) {
    if (slots.isEmpty) {
      return 'No time slots exist';
    } else {
      List<String?> endTimes = slots.map((s) => s.endTime).toList();

      endTimes.sort();
      final formattedDate = DateFormat(
        'yyyy-MM-dd',
      ).format(DateTime.parse(date));

      final latestEnd = '$formattedDate, ${endTimes.last}';
      print('Latest end time: $latestEnd');

      return latestEnd;
    }
  }

  static double calculateEnergyAmount(
    DateTime date,
    List<SlotModel> slots,
    double powerKw,
  ) {
    if (slots.isEmpty) return 0;

    final formattedDate = DateFormat('yyyy-MM-dd').format(date);

    double totalHours = 0;

    for (final slot in slots) {
      if (slot.startTime == null || slot.endTime == null) continue;

      final start = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).parse('$formattedDate ${slot.startTime}');
      final end = DateFormat(
        'yyyy-MM-dd HH:mm',
      ).parse('$formattedDate ${slot.endTime}');

      final minutes = end.difference(start).inMinutes;

      if (minutes <= 0) continue;

      totalHours += minutes / 60.0;
    }

    print("Total hours: $totalHours");
    print("Power kW: $powerKw");

    return totalHours * powerKw;
  }

  static double calculatePrice(
    double powerKw,
    double pricePerKwh,
  ) {
    if (powerKw == 0.0) return 0;

    return powerKw * pricePerKwh;
  }

  static List<SlotModel> convertSelectedSlotsToTimeSlots(
    List<SlotModel> selectedSlots,
    List<SlotModel> allSlots,
  ) {
    return allSlots.where((slot) => selectedSlots.contains(slot)).toList();
  }

  static String? convertTimeSlotsToTimeRange(List<TimeSlotModel> timeSlots) {
    if (timeSlots.isEmpty) {
      return 'No time slots exist';
    } else {
      int todayDayOfWeek = DateTime.now().weekday;

      final todaySlot = timeSlots.firstWhere(
        (slot) => slot.availableDays?.contains(todayDayOfWeek) ?? false,
        orElse: () => TimeSlotModel(
          id: '',
          startTime: null,
          endTime: null,
        ),
      );

      if (todaySlot.startTime == null || todaySlot.endTime == null) {
        return 'No available time today';
      }

      return '${todaySlot.startTime} - ${todaySlot.endTime}';
    }
  }
}
