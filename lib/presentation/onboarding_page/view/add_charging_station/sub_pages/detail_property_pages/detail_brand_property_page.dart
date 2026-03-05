import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/bloc/charging_station_event.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/details_widget.dart';
import 'package:watt/presentation/onboarding_page/view/add_charging_station/components/tall_card_selector.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';

class DetailBrandPropertyPage extends StatefulWidget {
  final String selectedBrand;

  const DetailBrandPropertyPage({
    super.key,
    required this.selectedBrand,
  });

  @override
  State<DetailBrandPropertyPage> createState() =>
      _DetailBrandPropertyPageState();
}

class _DetailBrandPropertyPageState extends State<DetailBrandPropertyPage> {
  String? tempSelectedBrand;
  String? brandLogo;

  @override
  void initState() {
    tempSelectedBrand = widget.selectedBrand;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DetailsWidget(
      title: 'Charging Station Brand',
      content: Container(
        color: context.theme.appColors.background,
        padding: const EdgeInsets.only(top: 20.0),
        child: Column(
          children: [
            ...List.generate(
              KChargingStation.chargingStationList.length,
              (index) {
                final brandName = KChargingStation.chargingStationList
                    .elementAt(index);
                brandLogo = KChargingStation.chargingStationIconsList.elementAt(
                  index,
                );

                return TallCardSelector(
                  label: brandName,
                  pngImage: KChargingStation.chargingStationIconsList.elementAt(
                    index,
                  ),
                  isSelected: tempSelectedBrand == brandName,
                  onSelected: (newBrand) {
                    setState(() {
                      tempSelectedBrand = newBrand;
                    });
                  },
                );
              },
            ),
          ],
        ),
      ),
      onPressed: () {
        context.read<ChargingStationBloc>().add(
          UpdateBrandNamePropertyEvent(
            tempSelectedBrand ?? '',
            brandLogo ?? '',
          ),
        );

        Navigator.pop(context);
      },
    );
  }
}
