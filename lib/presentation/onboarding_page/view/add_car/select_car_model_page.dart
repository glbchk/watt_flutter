import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_event.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/components/select_car_model_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';

class SelectCarModelPage extends StatefulWidget {
  final String brandLogo;
  final String brandName;
  final MockedCarBrand brand;

  const SelectCarModelPage({
    super.key,
    required this.brandLogo,
    required this.brandName,
    required this.brand,
  });

  @override
  State<SelectCarModelPage> createState() => _SelectCarModelPageState();
}

class _SelectCarModelPageState extends State<SelectCarModelPage> {
  TextEditingController plateController = TextEditingController();
  // var items = ['One', 'Two', 'Three', 'Four'];
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    context.read<OnboardingBloc>().add(FetchMockedCarModelOptionsEvent());
  }

  @override
  void dispose() {
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingBloc, OnboardingState>(
      builder: (context, state) {
        List<String> getModelList(
          MockedCarBrand? selectedBrand,
          Map<MockedCarBrand, List<String>>? carLists,
        ) {
          if (selectedBrand == null || carLists == null) {
            return [];
          }

          return carLists[selectedBrand] ?? [];
        }

        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          title: widget.brandName,
          titleColor: context.theme.appColors.onPrimary,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          body: SelectCarModelWidget(
            controllerPlateNumber: plateController,
            listItems: getModelList(widget.brand, state.carModelOptions),
            selectedValue: _dropdownValue,
            onDropdownChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue ?? '';
              });
            },
            onSavePressed: () {
              context.read<OnboardingBloc>().add(
                OnboardingFilledCarModelEvent(
                  car: CarModel(
                    id: Uuid().v4(),
                    brandLogo: widget.brandLogo,
                    brandName: widget.brandName,
                    carModel: _dropdownValue ?? '',
                    plateNumber: plateController.text,
                  ),
                ),
              );
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}
