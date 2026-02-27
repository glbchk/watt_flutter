import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/models/payment_method_model.dart';
import 'package:watt/data/models/timeslot_model.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_address_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_available_hours_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_bank_account_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_brand_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_charging_effect_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_name_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_plug_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/detail_property_pages/detail_price_property_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/sub_pages/extra_pages/add_iban_in_charging_station.dart';
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

class DetailsPage extends StatefulWidget {
  final DetailPageProperties property;
  final String? chargingStationId;
  final String? brandName;

  const DetailsPage({
    super.key,
    required this.property,
    this.chargingStationId,
    this.brandName,
  });

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  TextEditingController controllerName = TextEditingController();
  TextEditingController controllerAddress = TextEditingController();
  TextEditingController controllerPrice = TextEditingController();

  String? tempSelectedBrand;
  String? selectedChargingEffect;
  String? selectedPlugType;
  TimeSlotModel? availableHours;

  @override
  void dispose() {
    controllerName.dispose();
    controllerAddress.dispose();
    controllerPrice.dispose();
    super.dispose();
  }

  String titleSelector() {
    return switch (widget.property) {
      DetailPageProperties.chargingStationName => 'How to name your charger?',
      DetailPageProperties.address => 'Address',
      DetailPageProperties.brandName => 'Charging Station Brand',
      DetailPageProperties.chargingEffect => 'Charging effect',
      DetailPageProperties.plug => 'Plug',
      DetailPageProperties.pricePerKwh => 'Price per kWh',
      DetailPageProperties.bankAccount => 'Bank account',
      DetailPageProperties.availableHours => 'Available hours',
    };
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChargingStationBloc, ChargingStationState>(
      builder: (context, state) {
        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          title: titleSelector(),
          foregroundColor: context.theme.appColors.onSurface,
          appBarBackgroundColor: context.theme.appColors.surface,

          body: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildPropertyWidget(),
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
                      context.read<ChargingStationBloc>().add(
                        UpdateChargingStationPropertyEvent(
                          widget.property,
                          _getCorrectValue(widget.property),

                          ///TODO:Need to fix here
                          state.bankAccount ??
                              IbanModel(
                                ibanNumber: '',
                                id: '',
                                isUsedForReceivingEarnings: false,
                              ),
                        ),
                      );

                      Navigator.pop(context);
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

  Widget _buildPropertyWidget() {
    return switch (widget.property) {
      DetailPageProperties.chargingStationName => DetailNamePropertyWidget(
        controllerName: controllerName,
      ),
      DetailPageProperties.address => DetailAddressPropertyWidget(
        controllerAddress: controllerAddress,
      ),
      DetailPageProperties.brandName => DetailBrandPropertyWidget(
        selectedBrand: tempSelectedBrand ?? 'Other',
        onPressed: (newBrand) {
          setState(() {
            if (newBrand.isNotEmpty) {
              tempSelectedBrand = newBrand;
            } else {
              tempSelectedBrand = widget.brandName;
            }
          });
        },
      ),
      DetailPageProperties.chargingEffect => DetailChargingEffectPropertyWidget(
        selectedValue: selectedChargingEffect,
        onSelected: (String value) {
          setState(() {
            selectedChargingEffect = value;
          });
        },
      ),
      DetailPageProperties.plug => DetailPlugPropertyWidget(
        selectedValue: selectedPlugType,
        onSelected: (String value) {
          setState(() {
            selectedPlugType = value;
          });
        },
      ),
      DetailPageProperties.pricePerKwh => DetailPricePropertyWidget(
        controllerPrice: controllerPrice,
      ),
      DetailPageProperties.bankAccount => DetailBankAccountPropertyWidget(
        onPress: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddIbanInChargingStationPage(),
            ),
          );
        },
      ),
      DetailPageProperties.availableHours => DetailAvailableHoursPropertyWidget(
        onPress: () {},
      ),
    };
  }

  String _getCorrectValue(DetailPageProperties property) {
    return switch (property) {
      DetailPageProperties.chargingStationName => controllerName.text,
      DetailPageProperties.address => controllerAddress.text,
      DetailPageProperties.brandName => tempSelectedBrand ?? '',
      DetailPageProperties.chargingEffect => selectedChargingEffect ?? '',
      DetailPageProperties.plug => selectedPlugType ?? '',
      DetailPageProperties.pricePerKwh => controllerPrice.text,
      _ => "",
    };
  }
}
