import 'package:flutter/material.dart';
import 'package:watt/utils/global_components/row_button.dart';

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
  });

  @override
  State<ChargerStationDetailsFormWidget> createState() =>
      _ChargerStationDetailsFormWidgetState();
}

class _ChargerStationDetailsFormWidgetState
    extends State<ChargerStationDetailsFormWidget> {
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
            ),
            RowButton(
              label: 'Brand',
              secondLabel: 'Easee',
            ),
            RowButton(
              label: 'Charging effect',
            ),
            RowButton(
              label: 'Plug',
            ),
            RowButton(
              label: 'Price per kWh',
            ),
            RowButton(
              label: 'IBAN',
            ),
            RowButton(
              label: 'Online charger',
            ),
            RowButton(
              label: 'Available hours',
            ),
            RowButton(
              label: 'Everyone can access',
            ),
          ],
        ),
      ),
    );
  }
}
