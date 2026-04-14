import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/presentation/settings_pages/profile_page/enum/profile_data_type_enum.dart';
import 'package:watt/presentation/settings_pages/profile_page/sub_pages/edit_profile_data_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/row_button.dart';
import 'package:watt/utils/global_components/watt_white_button.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    super.initState();
    context.read<ProfileCubit>().fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        print(state.userData?.name);
        print(state.userData?.email);
        print(state.userData);
        // if (state.isLoading) {
        //   return const Scaffold(
        //     body: Center(child: CircularProgressIndicator()),
        //   );
        // }

        if (state.userData == null) {
          return const Scaffold(
            body: Center(child: Text('No user data')),
          );
        }

        final user = state.userData;

        return DefaultAppBar(
          resizeToAvoidBottomInset: true,
          extendBodyBehindAppBar: false,
          appBarBackgroundColor: context.theme.appColors.transparent,
          scaffoldBackgroundColor: context.theme.appColors.primary,
          leading: BackButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          body: Column(
            children: [
              Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  gradient: wattGradient,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Profile',
                      style: TextStyle(
                        color: context.theme.appColors.background,
                        fontWeight: FontWeight.bold,
                        fontSize: 28,
                      ),
                    ),
                    Text(
                      'Here you will find your information',
                      style: TextStyle(
                        color: context.theme.appColors.background,
                        fontWeight: FontWeight.normal,
                        fontSize: 15,
                      ),
                    ),
                    SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  color: context.theme.appColors.background,
                  child: Transform.translate(
                    offset: Offset(0, -40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: context.theme.appColors.background,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30.0),
                                  topRight: Radius.circular(30.0),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 20.0,
                                  right: 20.0,
                                  top: 10.0,
                                ),
                                child: Column(
                                  children: [
                                    RowButton(
                                      label: 'Name',
                                      secondLabel:
                                          user?.name ?? 'No name found',
                                      // hideChevron: false,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProfileDataPage(
                                              type: ProfileDataType.editName,
                                              value: user?.name ?? '',
                                              onPressed: (String name) {
                                                context
                                                    .read<ProfileCubit>()
                                                    .editNameUserData(name);
                                                Navigator.of(context).pop();
                                              },
                                              error: state.nameError,
                                              onChanged: (String? value) {
                                                context
                                                    .read<ProfileCubit>()
                                                    .verifyNameUserData(
                                                      value ?? '',
                                                    );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    RowButton(
                                      label: 'Email',
                                      secondLabel:
                                          user?.email ?? 'No email found',
                                      // hideChevron: false,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProfileDataPage(
                                              type: ProfileDataType.editEmail,
                                              value: user?.email ?? '',
                                              onPressed: (String email) async {
                                                await context
                                                    .read<ProfileCubit>()
                                                    .editEmailUserData(email);

                                                final latestState = context
                                                    .read<ProfileCubit>()
                                                    .state;

                                                if (latestState.errorMessage ==
                                                    null) {
                                                  FocusScope.of(
                                                    context,
                                                  ).unfocus();
                                                  Navigator.of(
                                                    context,
                                                  ).pop();
                                                }
                                              },
                                              error: state.emailError,
                                              onChanged: (String? value) {
                                                context
                                                    .read<ProfileCubit>()
                                                    .verifyEmailUserData(
                                                      value ?? '',
                                                    );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    RowButton(
                                      label: 'Mobile',
                                      secondLabel:
                                          user?.phoneNumber ??
                                          'No phone number found',
                                      // hideChevron: false,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProfileDataPage(
                                              type: ProfileDataType
                                                  .editPhoneNumber,
                                              value: user?.phoneNumber ?? '',
                                              onPressed: (String phoneNumber) {
                                                context
                                                    .read<ProfileCubit>()
                                                    .editPhoneNumberUserData(
                                                      phoneNumber,
                                                    );
                                                Navigator.of(context).pop();
                                              },
                                              error: state.phoneNumberError,
                                              onChanged: (String? value) {
                                                context
                                                    .read<ProfileCubit>()
                                                    .verifyPhoneNumberUserData(
                                                      value ?? '',
                                                    );
                                              },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    SizedBox(height: 30),
                                    WattWhiteButton(
                                      label: 'Change password',
                                      onPressed: () {},
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // void _showReauthDialog(BuildContext context, password) {
  //   final passwordController = TextEditingController();
  //   final state = context.read<ProfileCubit>().state;
  //
  //   showDialog(
  //     context: context,
  //     builder: (diagContext) => LoginAlertWidget(
  //       title: "Confirm Identity",
  //       emailController: ,
  //       emailError: ,
  //       onEmailChanged: ,
  //       passwordController: ,
  //       passwordError: ,
  //       onPasswordChanged: ,
  //       onConfirm: () {
  //         Navigator.pop(diagContext);
  //       },
  //       // onCancel: () {
  //       //   Navigator.pop(diagContext);
  //       // },
  //       content: Column(
  //         mainAxisSize: MainAxisSize.min,
  //         children: [
  //           const Text("Please enter your password to change your email."),
  //           TextField(
  //             controller: passwordController,
  //             obscureText: true,
  //             decoration: const InputDecoration(labelText: 'Password'),
  //           ),
  //         ],
  //       ),
  //       actions: [
  //         TextButton(
  //           onPressed: () => Navigator.pop(diagContext),
  //           child: const Text("Cancel"),
  //         ),
  //         ElevatedButton(
  //           onPressed: () {
  //             // Call the reauthenticate method you created in the Cubit
  //             context.read<ProfileCubit>().reauthenticateUser(
  //               passwordController.text,
  //               ProfileDataType.editEmail,
  //               // You'll need to pass the temporary email here
  //               // or store it in your state
  //               state.newEmailValue ?? '',
  //             );
  //             Navigator.pop(diagContext);
  //           },
  //           child: const Text("Confirm"),
  //         ),
  //       ],
  //     ),
  //   );
  // }
}
