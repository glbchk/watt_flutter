import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';

class ChargingStationState {
  final bool? isLoading;
  final String? errorMessage;

  final String? id;
  final String? chargingStationName;
  final String? address;
  final String? brandName;
  final String? brandLogo;
  final String? chargingEffect;
  final String? plug;
  final String? pricePerKwh;
  final IbanModel? bankAccount;
  final bool? onlineCharger;
  final List<TimeSlotModel>? availableHours;
  final bool? everyoneCanAccess;

  const ChargingStationState({
    this.isLoading = false,
    this.errorMessage,
    this.id,
    this.chargingStationName,
    this.address,
    this.brandName,
    this.brandLogo,
    this.chargingEffect,
    this.plug,
    this.pricePerKwh,
    this.bankAccount,
    this.onlineCharger = false,
    this.availableHours,
    this.everyoneCanAccess = false,
  });

  ChargingStationState copyWith({
    bool? Function()? isLoading,
    String? Function()? errorMessage,
    String? Function()? id,
    String? Function()? chargingStationName,
    String? Function()? address,
    String? Function()? brandName,
    String? Function()? brandLogo,
    String? Function()? chargingEffect,
    String? Function()? plug,
    String? Function()? pricePerKwh,
    IbanModel? Function()? bankAccount,
    bool? Function()? onlineCharger,
    List<TimeSlotModel>? Function()? availableHours,
    bool? Function()? everyoneCanAccess,
  }) {
    return ChargingStationState(
      isLoading: isLoading != null ? isLoading() : this.isLoading,
      errorMessage: errorMessage != null ? errorMessage() : this.errorMessage,
      id: id != null ? id() : this.id,
      chargingStationName: chargingStationName != null
          ? chargingStationName()
          : this.chargingStationName,
      address: address != null ? address() : this.address,
      brandName: brandName != null ? brandName() : this.brandName,
      brandLogo: brandLogo != null ? brandLogo() : this.brandLogo,
      chargingEffect: chargingEffect != null
          ? chargingEffect()
          : this.chargingEffect,
      plug: plug != null ? plug() : this.plug,
      pricePerKwh: pricePerKwh != null ? pricePerKwh() : this.pricePerKwh,
      bankAccount: bankAccount != null ? bankAccount() : this.bankAccount,
      onlineCharger: onlineCharger != null
          ? onlineCharger()
          : this.onlineCharger,
      availableHours: availableHours != null
          ? availableHours()
          : this.availableHours,
      everyoneCanAccess: everyoneCanAccess != null
          ? everyoneCanAccess()
          : this.everyoneCanAccess,
    );
  }
}
