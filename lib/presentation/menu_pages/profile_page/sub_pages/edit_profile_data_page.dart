import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/components/edit_data_widget.dart';
import 'package:watt/presentation/menu_pages/profile_page/enum/profile_data_type_enum.dart';
import 'package:watt/presentation/menu_pages/profile_page/sub_pages/email_verification_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/custom_textfield.dart';
import 'package:watt/utils/global_components/login_alert.dart';

class EditProfileDataPage extends StatefulWidget {
  final ProfileDataType type;
  final String value;
  final Function(String) onPressed;
  final String? error;
  final Function(String?)? onChanged;
  final VoidCallback? onLinkTap;

  const EditProfileDataPage({
    super.key,
    this.type = ProfileDataType.editName,
    required this.value,
    required this.onPressed,
    this.error,
    this.onChanged,
    this.onLinkTap,
  });

  @override
  State<EditProfileDataPage> createState() => _EditProfileDataPageState();
}

class _EditProfileDataPageState extends State<EditProfileDataPage> {
  TextEditingController controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.text = widget.value;

    if (widget.type == ProfileDataType.editEmail) {
      context.read<ProfileCubit>().checkVerificationEmailAndUpdate(
        controller.text,
      );
    }
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String? title;
    String? label;

    switch (widget.type) {
      case ProfileDataType.editName:
        title = 'What is your name?';
        label = 'Name';
        break;
      case ProfileDataType.editEmail:
        title = 'What is your email?';
        label = 'Email';
        break;
      case ProfileDataType.editPhoneNumber:
        title = 'What is your phone number?';
        label = 'Phone Number';
        break;
    }

    return BlocConsumer<ProfileCubit, ProfileState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage,
      listener: (context, state) {
        if (state.errorMessage == 'reauth-required') {
          final cubit = context.read<ProfileCubit>();
          final emailToUpdate = controller.text;

          LoginAlertWidget.show(
            context: context,
            title: "Confirm Identity",
            message: "Please enter your password to change your email.",
            buttonLabel: 'Confirm',
            onConfirm: (String password) async {
              try {
                await cubit.reauthenticateUser(
                  password,
                  ProfileDataType.editEmail,
                  emailToUpdate,
                );

                if (!context.mounted) return;

                Navigator.of(context).pop();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => EmailVerificationPage(
                      pendingEmail: emailToUpdate,
                    ),
                  ),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(e.toString())),
                );
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
                if (widget.type == ProfileDataType.editEmail &&
                    (state.isEmailVerified == null ||
                        state.isEmailVerified == false))
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: context.theme.appColors.grey4,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: 'Email is not verified, ',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.appColors.primary,
                                ),
                              ),
                              TextSpan(
                                text: 'CLICK TO SEND VERIFICATION EMAIL',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: context.theme.appColors.primary,
                                  decoration: TextDecoration.underline,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = widget.onLinkTap,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
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
