import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/presentation/menu_pages/profile_page/enum/profile_data_type_enum.dart';
import 'package:watt/presentation/menu_pages/profile_page/sub_pages/edit_profile_data_page.dart';
import 'package:watt/presentation/menu_pages/profile_page/sub_pages/email_verification_page.dart';
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
              context.read<ProfileCubit>().clearError();
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
                                      secondLabel: state.name ?? user?.name,
                                      // hideChevron: false,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProfileDataPage(
                                              type: ProfileDataType.editName,
                                              value:
                                                  state.name ??
                                                  user?.name ??
                                                  '',
                                              onPressed: (String name) {
                                                context
                                                    .read<ProfileCubit>()
                                                    .editNameUserData(name);
                                                if (context.mounted) {
                                                  Navigator.of(context).pop();
                                                }
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
                                      secondLabel: state.email ?? user?.email,
                                      // hideChevron: false,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProfileDataPage(
                                              type: ProfileDataType.editEmail,
                                              value:
                                                  state.email ??
                                                  user?.email ??
                                                  '',
                                              error: state.emailError,
                                              onChanged: (String? value) {
                                                context
                                                    .read<ProfileCubit>()
                                                    .verifyEmailUserData(
                                                      value ?? '',
                                                    );
                                              },
                                              onLinkTap: () {
                                                context
                                                    .read<ProfileCubit>()
                                                    .sendVerificationEmail();

                                                if (state.isEmailVerified ==
                                                    true) {
                                                  Navigator.of(
                                                    context,
                                                  ).pop();
                                                } else {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (_) =>
                                                          EmailVerificationPage(
                                                            pendingEmail:
                                                                state.email ??
                                                                '',
                                                          ),
                                                    ),
                                                  );
                                                }
                                              },
                                              onPressed:
                                                  (String newEmail) async {
                                                    final cubit = context
                                                        .read<ProfileCubit>();

                                                    await cubit.updateEmail(
                                                      newEmail,
                                                    );
                                                    final latestState =
                                                        cubit.state;

                                                    if (latestState
                                                            .errorMessage ==
                                                        'reauth-required') {
                                                      return;
                                                    }

                                                    if (context.mounted) {
                                                      FocusScope.of(
                                                        context,
                                                      ).unfocus();
                                                      Navigator.of(
                                                        context,
                                                      ).pop();
                                                    }
                                                  },
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                    RowButton(
                                      label: 'Mobile',
                                      secondLabel:
                                          state.phoneNumber ??
                                          user?.phoneNumber,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) => EditProfileDataPage(
                                              type: ProfileDataType
                                                  .editPhoneNumber,
                                              value:
                                                  state.phoneNumber ??
                                                  user?.phoneNumber ??
                                                  '',
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
}
