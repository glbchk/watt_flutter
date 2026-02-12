import 'package:flutter/material.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/global_components/tile_selector_widget.dart';

List<String> chargingEffectList = [
  KChargingEffect.three,
  KChargingEffect.seven,
  KChargingEffect.eleven,
  KChargingEffect.twentyTwo,
];

List<String> plugList = [
  KPlugs.threePhase,
  KPlugs.typeOne,
  KPlugs.typeTwo,
  KPlugs.wall,
];

class DetailPlugPropertyWidget extends StatefulWidget {
  final ValueChanged<String>? onSelected;

  const DetailPlugPropertyWidget({
    super.key,
    this.onSelected,
  });

  @override
  State<DetailPlugPropertyWidget> createState() =>
      _DetailPlugPropertyWidgetState();
}

class _DetailPlugPropertyWidgetState extends State<DetailPlugPropertyWidget> {
  String? selectedPlug;

  @override
  Widget build(BuildContext context) {
    return TileSelectorWidget(
      prefixIcon: Icons.settings_input_hdmi_outlined,
      list: plugList,
      selectedValue: selectedPlug,
      onSelected: (value) {
        setState(() => selectedPlug = value);
      },
    );
  }
}
