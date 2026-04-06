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

  static String getAssetPath(String cardType) {
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

  static List<SlotModel> generate30MinuteSlots(
    String startTime,
    String endTime,
  ) {
    List<SlotModel> slots = [];

    final DateFormat formatter = DateFormat('HH:mm');
    final DateTime now = DateTime.now();

    try {
      DateTime start = formatter.parse(startTime);
      DateTime end = formatter.parse(endTime);

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
            timeSlot:
                '${formatter.format(currentSlot)} - ${formatter.format(nextSlot)}',
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

  static List<TimeSlotModel> convertSelectedSlotsToTimeSlots(
    Set<String> selectedSlots,
  ) {
    return selectedSlots.map((slot) {
      final parts = slot.split('-');

      if (parts.length != 2) {
        return TimeSlotModel(
          id: Uuid().v4(),
          startTime: null,
          endTime: null,
        );
      }

      return TimeSlotModel(
        id: Uuid().v4(),
        startTime: parts[0].trim(),
        endTime: parts[1].trim(),
      );
    }).toList();
  }
}
