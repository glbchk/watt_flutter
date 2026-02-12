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
  final VoidCallback? onIbanPressed;
  final VoidCallback? onOnlineChargerPressed;
  final VoidCallback? onAvailableHoursPressed;
  final String brandName;

  const ChargerStationDetailsFormWidget({
    super.key,
    this.onNamePressed,
    this.onAddressPressed,
    this.onBrandPressed,
    this.onChargingEffectPressed,
    this.onPlugPressed,
    this.onPricePressed,
    this.onIbanPressed,
    this.onOnlineChargerPressed,
    this.onAvailableHoursPressed,
    required this.brandName,
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
              onPressed: widget.onNamePressed,
            ),
            RowButton(
              label: 'Address',
              onPressed: widget.onAddressPressed,
            ),
            RowButton(
              label: 'Brand',
              secondLabel: widget.brandName,
              onPressed: widget.onBrandPressed,
            ),
            RowButton(
              label: 'Charging effect',
              onPressed: widget.onChargingEffectPressed,
            ),
            RowButton(
              label: 'Plug',
              onPressed: widget.onPlugPressed,
            ),
            RowButton(
              label: 'Price per kWh',
              onPressed: widget.onPricePressed,
            ),
            RowButton(
              label: 'Bank account',
              onPressed: widget.onIbanPressed,
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
