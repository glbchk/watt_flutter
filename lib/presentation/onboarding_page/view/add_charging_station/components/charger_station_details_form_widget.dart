import 'package:flutter/material.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/row_toggle.dart';

class ChargerStationDetailsFormWidget extends StatefulWidget {
  final VoidCallback? onNamePressed;
  final VoidCallback? onAddressPressed;
  final VoidCallback? onBrandPressed;
  final VoidCallback? onChargingEffectPressed;
  final VoidCallback? onPlugPressed;
  final VoidCallback? onPricePressed;
  final VoidCallback? onBankAccountPressed;
  final VoidCallback? onOnlineChargerPressed;
  final VoidCallback? onAvailableHoursPressed;
  final String chargingStationName;
  final String brandName;
  final String address;
  final String chargingEffect;
  final String plug;
  final String price;
  final String bankAccount;
  final String availableHours;

  const ChargerStationDetailsFormWidget({
    super.key,
    this.onNamePressed,
    this.onAddressPressed,
    this.onBrandPressed,
    this.onChargingEffectPressed,
    this.onPlugPressed,
    this.onPricePressed,
    this.onBankAccountPressed,
    this.onOnlineChargerPressed,
    this.onAvailableHoursPressed,
    required this.chargingStationName,
    required this.brandName,
    required this.address,
    required this.chargingEffect,
    required this.plug,
    required this.price,
    required this.bankAccount,
    required this.availableHours,
  });

  @override
  State<ChargerStationDetailsFormWidget> createState() =>
      _ChargerStationDetailsFormWidgetState();
}

class _ChargerStationDetailsFormWidgetState
    extends State<ChargerStationDetailsFormWidget> {
  bool isSwitchedOnlineCharger = false;
  bool isSwitchedAccess = false;

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RowButton(
              label: 'Name',
              secondLabel: widget.chargingStationName,
              onPressed: widget.onNamePressed,
            ),
            RowButton(
              label: 'Address',
              secondLabel: widget.address,
              onPressed: widget.onAddressPressed,
            ),
            RowButton(
              label: 'Brand',
              secondLabel: widget.brandName,
              onPressed: widget.onBrandPressed,
            ),
            RowButton(
              label: 'Charging effect',
              secondLabel: widget.chargingEffect,
              onPressed: widget.onChargingEffectPressed,
            ),
            RowButton(
              label: 'Plug',
              secondLabel: widget.plug,
              onPressed: widget.onPlugPressed,
            ),
            RowButton(
              label: 'Price per kWh',
              secondLabel: widget.price,
              onPressed: widget.onPricePressed,
            ),
            RowButton(
              label: 'Bank account',
              secondLabel: widget.bankAccount,
              onPressed: widget.onBankAccountPressed,
            ),
            RowToggle(
              label: 'Online charger',
              isSwitched: isSwitchedOnlineCharger,
              onChanged: (bool newValue) {
                setState(() {
                  isSwitchedOnlineCharger = newValue;
                });
              },
            ),
            RowButton(
              label: 'Available hours',
              secondLabel: widget.availableHours,
              onPressed: widget.onAvailableHoursPressed,
            ),
            RowToggle(
              label: 'Everyone can access',
              isSwitched: isSwitchedAccess,
              onChanged: (bool newValue) {
                setState(() {
                  isSwitchedAccess = newValue;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
