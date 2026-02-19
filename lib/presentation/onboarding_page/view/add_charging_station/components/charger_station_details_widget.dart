import 'package:flutter/material.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/row_toggle.dart';

enum PropertyType { button, toggle }

class PropertyOption {
  final String propertyName;
  final String? secondLabel;
  final PropertyType type;
  final VoidCallback? action;
  final ValueChanged<bool>? onToggle;
  final bool initialToggleValue;

  PropertyOption({
    required this.propertyName,
    this.secondLabel,
    this.type = PropertyType.button,
    this.action,
    this.onToggle,
    this.initialToggleValue = false,
  });
}

class ChargerStationDetailsWidget extends StatefulWidget {
  final VoidCallback? onNamePressed;
  final VoidCallback? onAddressPressed;
  final VoidCallback? onBrandPressed;
  final VoidCallback? onChargingEffectPressed;
  final VoidCallback? onPlugPressed;
  final VoidCallback? onPricePressed;
  final VoidCallback? onBankAccountPressed;
  final ValueChanged<bool>? onOnlineChargerPressed;
  final VoidCallback? onAvailableHoursPressed;
  final ValueChanged<bool>? onEveryoneCanAccessPressed;
  final String? chargingStationName;
  final String? brandName;
  final String? address;
  final String? chargingEffect;
  final String? plug;
  final String? price;
  final String? bankAccount;
  final String? availableHours;

  const ChargerStationDetailsWidget({
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
    this.onEveryoneCanAccessPressed,
    this.chargingStationName,
    this.brandName,
    this.address,
    this.chargingEffect,
    this.plug,
    this.price,
    this.bankAccount,
    this.availableHours,
  });

  @override
  State<ChargerStationDetailsWidget> createState() =>
      _ChargerStationDetailsWidgetState();
}

class _ChargerStationDetailsWidgetState
    extends State<ChargerStationDetailsWidget> {
  bool isSwitchedOnlineCharger = false;
  bool isSwitchedAccess = false;

  @override
  Widget build(BuildContext context) {
    final List<PropertyOption> properties = [
      PropertyOption(
        propertyName: 'Name',
        secondLabel: widget.chargingStationName,
        action: widget.onNamePressed,
      ),
      PropertyOption(
        propertyName: 'Address',
        secondLabel: widget.address,
        action: widget.onAddressPressed ?? () {},
      ),
      PropertyOption(
        propertyName: 'Brand',
        secondLabel: widget.brandName,
        action: widget.onBrandPressed ?? () {},
      ),
      PropertyOption(
        propertyName: 'Charging effect',
        secondLabel: widget.chargingEffect,
        action: widget.onChargingEffectPressed ?? () {},
      ),
      PropertyOption(
        propertyName: 'Plug',
        secondLabel: widget.plug,
        action: widget.onPlugPressed ?? () {},
      ),
      PropertyOption(
        propertyName: 'Price per kWh',
        secondLabel: widget.price,
        action: widget.onPricePressed ?? () {},
      ),
      PropertyOption(
        propertyName: 'Bank account',
        secondLabel: widget.bankAccount,
        action: widget.onBankAccountPressed ?? () {},
      ),
      PropertyOption(
        propertyName: 'Online charger',
        type: PropertyType.toggle,
        initialToggleValue: isSwitchedOnlineCharger,
        onToggle: (val) {
          setState(() => isSwitchedOnlineCharger = val);
          widget.onOnlineChargerPressed?.call(val);
        },
      ),
      PropertyOption(
        propertyName: 'Available hours',
        secondLabel: widget.availableHours,
        action: widget.onAvailableHoursPressed ?? () {},
      ),
      PropertyOption(
        propertyName: 'Everyone can access',
        type: PropertyType.toggle,
        initialToggleValue: isSwitchedAccess,
        onToggle: (val) {
          setState(() => isSwitchedAccess = val);
          widget.onEveryoneCanAccessPressed?.call(val);
        },
      ),
    ];

    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ...properties.map((property) {
            if (property.type == PropertyType.toggle) {
              return RowToggle(
                label: property.propertyName,
                isSwitched: property.initialToggleValue,
                onChanged: property.onToggle ?? (_) {},
              );
            } else {
              return RowButton(
                label: property.propertyName,
                secondLabel: property.secondLabel,
                onPressed: property.action,
              );
            }
          }),
        ],
      ),
    );
  }
}
