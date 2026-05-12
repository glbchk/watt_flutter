import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import 'package:watt/data/models/car_model.dart';
import 'package:watt/data/models/mock_data_models.dart';
import 'package:watt/presentation/menu_pages/cars_page/bloc/my_cars_cubit.dart';
import 'package:watt/presentation/menu_pages/cars_page/bloc/my_cars_state.dart';
import 'package:watt/presentation/onboarding_page/view/add_car/components/select_car_model_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';

class AddNewCarDetailsPage extends StatefulWidget {
  final String brandLogo;
  final String brandName;
  final MockedCarBrand brand;

  const AddNewCarDetailsPage({
    super.key,
    required this.brandLogo,
    required this.brandName,
    required this.brand,
  });

  @override
  State<AddNewCarDetailsPage> createState() => _AddNewCarDetailsPageState();
}

class _AddNewCarDetailsPageState extends State<AddNewCarDetailsPage> {
  TextEditingController plateController = TextEditingController();
  String? _dropdownValue;

  @override
  void initState() {
    super.initState();
    context.read<MyCarsCubit>().fetchMockedCarOptionsData();
    context.read<MyCarsCubit>().fetchMockedCarModelsData();
  }

  @override
  void dispose() {
    plateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MyCarsCubit, MyCarsState>(
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
          appBarBackgroundColor: context.theme.appColors.transparent,
          leading: BackButton(
            onPressed: () {
              context.read<MyCarsCubit>().clearErrors();

              Navigator.pop(context);
            },
          ),
          body: SelectCarModelWidget(
            controllerPlateNumber: plateController,
            errorModel: state.modelError,
            errorPlateNumber: state.plateNumberError,
            listItems: getModelList(widget.brand, state.carModelOptions),
            selectedValue: _dropdownValue,
            onDropdownChanged: (String? newValue) {
              setState(() {
                _dropdownValue = newValue;
                context.read<MyCarsCubit>().verifyModelSelection(
                  _dropdownValue ?? '',
                );
              });
            },
            onTextfieldChanged: (String? value) {
              context.read<MyCarsCubit>().verifyPlateNumber(value ?? '');
            },
            onSavePressed: () {
              final model = _dropdownValue ?? '';
              final plate = plateController.text.trim();

              final isModelValid = model.isNotEmpty;
              final isPlateValid =
                  plate.replaceAll(RegExp(r'\s+'), '').length == 6;

              if (!isModelValid || !isPlateValid) {
                context.read<MyCarsCubit>().verifyModelSelection(model);
                context.read<MyCarsCubit>().verifyPlateNumber(plate);
                return;
              }

              context.read<MyCarsCubit>().saveNewCar(
                CarModel(
                  id: Uuid().v4(),
                  brandLogo: widget.brandLogo,
                  brandName: widget.brandName,
                  carModel: model,
                  plateNumber: plate,
                ),
              );

              Navigator.of(context)
                ..pop()
                ..pop();
            },
          ),
        );
      },
    );
  }
}
