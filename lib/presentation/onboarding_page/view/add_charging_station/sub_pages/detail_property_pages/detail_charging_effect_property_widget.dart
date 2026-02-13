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

class DetailChargingEffectPropertyWidget extends StatefulWidget {
  final String? selectedValue;
  final ValueChanged<String> onSelected;

  const DetailChargingEffectPropertyWidget({
    super.key,
    this.selectedValue,
    required this.onSelected,
  });

  @override
  State<DetailChargingEffectPropertyWidget> createState() =>
      _DetailChargingEffectPropertyWidgetState();
}

class _DetailChargingEffectPropertyWidgetState
    extends State<DetailChargingEffectPropertyWidget> {
  @override
  Widget build(BuildContext context) {
    return TileSelectorWidget(
      list: chargingEffectList,
      selectedValue: widget.selectedValue,
      onSelected: widget.onSelected,
    );
  }
}
