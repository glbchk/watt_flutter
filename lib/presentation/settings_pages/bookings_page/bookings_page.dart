import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/view/auth_page.dart';
import 'package:watt/presentation/settings_pages/bloc/settings_cubit.dart';
import 'package:watt/presentation/settings_pages/bloc/settings_state.dart';
import 'package:watt/presentation/settings_pages/bookings_page/components/booking_card_widget.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';

class MyBookingsPage extends StatefulWidget {
  const MyBookingsPage({super.key});

  @override
  State<MyBookingsPage> createState() => _MyBookingsPageState();
}

class _MyBookingsPageState extends State<MyBookingsPage> {
  @override
  void initState() {
    super.initState();

    context.read<SettingsCubit>().fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listener: (context, state) {
        if (!state.isUserAuthenticated) {
          context.read<SettingsCubit>().logout();
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
        // if (state.isLoading) {
        //   return const Scaffold(
        //     body: Center(child: CircularProgressIndicator()),
        //   );
        // }
        //
        // if (state.userData == null) {
        //   return const Scaffold(
        //     body: Center(child: Text('No user data')),
        //   );
        // }

        final user = state.userData;

        return DefaultTabController(
          length: 2,
          child: DefaultAppBar(
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
            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
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
                              'Bookings',
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
                      Container(
                        color: context.theme.appColors.background,
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height / 1.3,
                        ),
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
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            top: 10.0,
                                            left: 20.0,
                                            right: 20.0,
                                          ),
                                          child: TabBar(
                                            labelColor: const Color(
                                              0xFF007AFF,
                                            ), // Active blue text
                                            unselectedLabelColor: Colors
                                                .grey
                                                .shade400, // Inactive grey text
                                            indicatorColor: const Color(
                                              0xFF007AFF,
                                            ), // Thick blue underline
                                            indicatorWeight:
                                                3.0, // Thickness of the blue line
                                            dividerColor: Colors
                                                .grey
                                                .shade300, // The full-width thin grey line
                                            indicatorSize: TabBarIndicatorSize
                                                .tab, // Stretches indicator across the whole tab
                                            labelStyle: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                            unselectedLabelStyle:
                                                const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ),
                                            tabs: const [
                                              Tab(text: 'Upcoming'),
                                              Tab(text: 'Past'),
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.7,
                                          child: TabBarView(
                                            children: [
                                              ListView.builder(
                                                padding: const EdgeInsets.only(
                                                  top: 5,
                                                ),
                                                itemCount: 1,
                                                itemBuilder: (context, index) {
                                                  return BookingCardWidget();
                                                },
                                              ),

                                              // Content for "Past"
                                              const Center(
                                                child: Text(
                                                  'No past bookings.',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 30),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
