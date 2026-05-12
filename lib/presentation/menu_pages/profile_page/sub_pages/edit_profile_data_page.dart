import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/components/edit_data_widget.dart';
import 'package:watt/presentation/menu_pages/profile_page/enum/profile_data_type_enum.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/login_alert.dart';

class EditProfileDataPage extends StatefulWidget {
  final ProfileDataType type;
  final String value;
  final Function(String) onPressed;
  final String? error;
  final Function(String?)? onChanged;

  const EditProfileDataPage({
    super.key,
    this.type = ProfileDataType.editName,
    required this.value,
    required this.onPressed,
    this.error,
    this.onChanged,
  });

  @override
  State<EditProfileDataPage> createState() => _EditProfileDataPageState();
}

class _EditProfileDataPageState extends State<EditProfileDataPage> {
  TextEditingController controller = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;
    context.read<ProfileCubit>().fetchUserData();
  }

  @override
  void dispose() {
    controller.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? title;
    String? label;
    // String? value;

    switch (widget.type) {
      case ProfileDataType.editName:
        title = 'What is your name?';
        label = 'Name';
        // value = 'Some name';
        break;
      case ProfileDataType.editEmail:
        title = 'What is your email?';
        label = 'Email';
        // value = 'Some email';
        break;
      case ProfileDataType.editPhoneNumber:
        title = 'What is your phone number?';
        label = 'Phone Number';
        // value = 'Some phone number';
        break;
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.errorMessage?.contains('reauth-required') ?? false) {
          LoginAlertWidget.show(
            context: context,
            title: "Confirm Identity",
            message: "Please enter your password to change your email.",
            passwordController: passwordController,
            passwordError: state.passwordError,
            buttonLabel: 'Confirm',
            onConfirm: () {
              if (state.passwordError != null) {
                context.read<ProfileCubit>().verifyPasswordUserData(
                  passwordController.text,
                );
              } else {
                context.read<ProfileCubit>().reauthenticateUser(
                  passwordController.text,
                  ProfileDataType.editEmail,
                  controller.text,
                );
                Navigator.pop(context);
              }
            },
          );
        }
      },
      builder: (context, state) {
        String? error;
        switch (widget.type) {
          case ProfileDataType.editName:
            error = state.nameError;
          case ProfileDataType.editEmail:
            error = state.emailError;
          case ProfileDataType.editPhoneNumber:
            error = state.phoneNumberError;
        }

        return EditDataWidget(
          title: title ?? '',
          content: Container(
            color: context.theme.appColors.background,
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CustomTextField(
                  controller: controller,
                  autofocus: true,
                  label: label,
                  hint: "e.g. John's Amp",
                  error: error,
                  onChanged: (String? value) => widget.onChanged?.call(value),
                ),
              ],
            ),
          ),
          onPressed: () {
            FocusScope.of(context).unfocus();

            widget.onPressed(controller.text);
          },
        );
      },
    );
  }
}
