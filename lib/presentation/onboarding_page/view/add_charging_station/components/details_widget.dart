import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

enum DetailPageProperties {
  chargingStationName,
  address,
  brandName,
  chargingEffect,
  plug,
  pricePerKwh,
  bankAccount,
  availableHours,
}

class DetailsWidget extends StatefulWidget {
  // final DetailPageProperties property;
  final String? chargingStationId;
  final String? brandName;
  final String title;
  final Widget content;
  final VoidCallback onPressed;

  const DetailsWidget({
    super.key,
    // required this.property,
    this.chargingStationId,
    this.brandName,
    required this.title,
    required this.content,
    required this.onPressed,
  });

  @override
  State<DetailsWidget> createState() => _DetailsWidgetState();
}

class _DetailsWidgetState extends State<DetailsWidget> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();
  TextEditingController controllerStartTime = TextEditingController();
  TextEditingController controllerEndTime = TextEditingController();

  String? tempSelectedBrand;
  String? selectedChargingEffect;
  String? selectedPlugType;
  List<TimeSlotModel>? availableHours = [];

  @override
  void dispose() {
    controllerName.dispose();
    controllerAddress.dispose();
    controllerPrice.dispose();
    controllerStartTime.dispose();
    controllerEndTime.dispose();
    super.dispose();
  }

  // String titleSelector() {
  //   return switch (widget.property) {
  //     DetailPageProperties.chargingStationName => 'How to name your charger?',
  //     DetailPageProperties.address => 'Address',
  //     DetailPageProperties.brandName => 'Charging Station Brand',
  //     DetailPageProperties.chargingEffect => 'Charging effect',
  //     DetailPageProperties.plug => 'Plug',
  //     DetailPageProperties.pricePerKwh => 'Price per kWh',
  //     DetailPageProperties.bankAccount => 'Bank account',
  //     DetailPageProperties.availableHours => 'Available hours',
  //   };
  // }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          title: widget.title,
          foregroundColor: context.theme.appColors.onSurface,
          appBarBackgroundColor: context.theme.appColors.surface,

          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: widget.content,
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(
                    left: 20.0,
                    top: 20.0,
                    right: 20.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom > 0
                        ? 12
                        : 34,
                  ),
                  child: WattMainButton(
                    label: 'Save',
                    onPressed: () {
                      widget.onPressed();
                      // context.read<ChargingStationBloc>().add(
                      //   UpdateChargingStationPropertyEvent(
                      //     widget.property,
                      //     _getCorrectValue(widget.property),
                      //
                      //     ///TODO:Need to fix here
                      //     state.bankAccount ??
                      //         IbanModel(
                      //           ibanNumber: '',
                      //           id: '',
                      //           isUsedForReceivingEarnings: false,
                      //         ),
                      //     availableHours ?? state.availableHours ?? [],
                      //   ),
                      // );
                      //
                      // Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

//   Widget _buildPropertyWidget() {
//     return switch (widget.property) {
//       DetailPageProperties.chargingStationName => DetailNamePropertyWidget(
//         controllerName: controllerName,
//       ),
//       DetailPageProperties.address => DetailAddressPropertyWidget(
//         controllerAddress: controllerAddress,
//       ),
//       DetailPageProperties.brandName => DetailBrandPropertyWidget(
//         selectedBrand: tempSelectedBrand ?? 'Other',
//         onPressed: (newBrand) {
//           setState(() {
//             if (newBrand.isNotEmpty) {
//               tempSelectedBrand = newBrand;
//             } else {
//               tempSelectedBrand = widget.brandName;
//             }
//           });
//         },
//       ),
//       DetailPageProperties.chargingEffect => DetailChargingEffectPropertyWidget(
//         selectedValue: selectedChargingEffect,
//         onSelected: (String value) {
//           setState(() {
//             selectedChargingEffect = value;
//           });
//         },
//       ),
//       DetailPageProperties.plug => DetailPlugPropertyWidget(
//         selectedValue: selectedPlugType,
//         onSelected: (String value) {
//           setState(() {
//             selectedPlugType = value;
//           });
//         },
//       ),
//       DetailPageProperties.pricePerKwh => DetailPricePropertyWidget(
//         controllerPrice: controllerPrice,
//       ),
//       DetailPageProperties.bankAccount => DetailBankAccountPropertyWidget(
//         onPress: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => AddIbanInChargingStationPage(),
//             ),
//           );
//         },
//       ),
//       DetailPageProperties.availableHours => DetailAvailableHoursPropertyWidget(
//         controllerStartTime: controllerStartTime,
//         controllerEndTime: controllerEndTime,
//         onPress: () {
//           final timeSlot = TimeSlotModel(
//             id: Uuid().v4(),
//             availableDays: daysList,
//             startTime: controllerStartTime.text,
//             endTime: controllerEndTime.text,
//           );
//
//           context.read<ChargingStationBloc>().add(
//             AddTimeSlotEvent(timeSlot),
//           );
//           Navigator.pop(context, timeSlot);
//         },
//       ),
//     };
//   }
//
//   String _getCorrectValue(DetailPageProperties property) {
//     return switch (property) {
//       DetailPageProperties.chargingStationName => controllerName.text,
//       DetailPageProperties.address => controllerAddress.text,
//       DetailPageProperties.brandName => tempSelectedBrand ?? '',
//       DetailPageProperties.chargingEffect => selectedChargingEffect ?? '',
//       DetailPageProperties.plug => selectedPlugType ?? '',
//       DetailPageProperties.pricePerKwh => controllerPrice.text,
//       DetailPageProperties.bankAccount => '',
//       DetailPageProperties.availableHours => '',
//       _ => "",
//     };
//   }
// }
//
// class WattAlert extends StatelessWidget {
//   final String? svg;
//   final String title;
//   final String? message;
//   final TextEditingController? controller;
//   final Function(String?)? onChanged;
//   final String? errorMessage;
//   final String? buttonLabel;
//   final VoidCallback? onConfirm;
//
//   const WattAlert({
//     super.key,
//     this.svg,
//     required this.title,
//     this.message,
//     this.controller,
//     this.onChanged,
//     this.errorMessage,
//     this.buttonLabel,
//     this.onConfirm,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       backgroundColor: context.theme.appColors.background,
//       insetPadding: const EdgeInsets.symmetric(horizontal: 20.0),
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           if (svg != null) const SizedBox(height: 80),
//           if (svg != null) SvgPicture.asset(svg ?? ''),
//           if (svg != null) const SizedBox(height: 20),
//           Text(
//             title,
//             style: const TextStyle(
//               fontWeight: FontWeight.bold,
//               fontSize: 22,
//             ),
//             textAlign: TextAlign.center,
//           ),
//           SizedBox(height: 12),
//           if (message != null)
//             Text(
//               message ?? '',
//               style: TextStyle(
//                 fontSize: 15,
//                 color: context.theme.appColors.onSurface,
//               ),
//               textAlign: TextAlign.center,
//             ),
//           if (message != null) const SizedBox(height: 30),
//           if (controller != null)
//             CustomTextField(
//               label: 'Email',
//               controller: controller,
//               autofocus: true,
//               hint: 'Start typing here',
//               onChanged: onChanged,
//               error: errorMessage,
//             ),
//           const SizedBox(height: 20),
//         ],
//       ),
//       actions: [
//         WattMainButton(
//           label: buttonLabel ?? '',
//           onPressed: () {
//             if (onConfirm != null) onConfirm?.call();
//           },
//         ),
//       ],
//     );
//   }
// }
