import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/view/auth_page.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/presentation/settings_pages/profile_page/sub_pages/edit_data_page.dart';
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
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (!state.isUserAuthenticated) {
          context.read<ProfileCubit>().logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => AuthPage()),
            (route) => false,
          );
        }
      },
      builder: (context, state) {
        print(state.userData?.name);
        print(state.userData?.email);
        print(state.userData);
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

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
              // context.read<OnboardingBloc>().add(
              //   NameVerificationEvent(value: ''),
              // );
              // context.read<OnboardingBloc>().add(
              //   PhoneNumberVerificationEvent(value: ''),
              // );
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
                                            builder: (_) => EditDataPage(
                                              type: EditDataType.editName,
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
                                            builder: (_) => EditDataPage(
                                              type: EditDataType.editEmail,
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
                                            builder: (_) => EditDataPage(
                                              type:
                                                  EditDataType.editPhoneNumber,
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
