// import 'package:flutter/material.dart';
// import 'package:watt/utils/global_components/row_button.dart';
// import 'package:watt/utils/global_components/row_toggle.dart';

// class ChargerStationDetailsWidget extends StatefulWidget {
//   final String nameLabel;
//   final String addressLabel;
//   final String brandLabel;
//   final String chargingEffectLabel;
//   final String plugLabel;
//   final String priceLabel;
//   final String bankAccountLabel;
//   final String availableHoursLabel;
//   final VoidCallback? action;
//   final bool initialToggleValue;
//   final ValueChanged<bool>? onToggle;
//
//   const ChargerStationDetailsWidget({
//     super.key,
//     required this.secondLabel,
//     this.action,
//     required this.initialToggleValue,
//     this.onToggle,
//   });
//
//   @override
//   State<ChargerStationDetailsWidget> createState() =>
//       _ChargerStationDetailsWidgetState();
// }
//
// class _ChargerStationDetailsWidgetState
//     extends State<ChargerStationDetailsWidget> {
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 20.0, right: 20.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           RowButton(
//             label: 'How to name your charger?',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowButton(
//             label: 'Address',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowButton(
//             label: 'Charging Station Brand',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowButton(
//             label: 'Charging effect',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowButton(
//             label: 'Plug',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowButton(
//             label: 'Price per kWh',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowButton(
//             label: 'Bank account',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowToggle(
//             label: 'Online charger',
//             isSwitched: widget.initialToggleValue,
//             onChanged: widget.onToggle ?? (_) {},
//           ),
//           RowButton(
//             label: 'Available hours',
//             secondLabel: widget.secondLabel,
//             onPressed: widget.action,
//           ),
//           RowToggle(
//             label: 'Everyone can access',
//             isSwitched: widget.initialToggleValue,
//             onChanged: widget.onToggle ?? (_) {},
//           ),
//         ],
//       ),
//     );
//   }
// }
