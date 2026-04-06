import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/auth_page/view/auth_page.dart';
import 'package:watt/presentation/settings_pages/bookings_page/components/booking_card_widget.dart';
import 'package:watt/presentation/settings_pages/bookings_page/components/past_booking_card_widget.dart';
import 'package:watt/presentation/settings_pages/bookings_page/sub_pages/past_booking_details_page.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/settings_pages/profile_page/bloc/profile_state.dart';
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
            showAppBar: false,
            // appBarBackgroundColor: context.theme.appColors.transparent,
            // scaffoldBackgroundColor: context.theme.appColors.primary,
            // leading: BackButton(
            //   onPressed: () {
            //     Navigator.of(context).pop();
            //   },
            // ),
            body: Stack(
              children: [
                CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      expandedHeight: 380.0,
                      flexibleSpace: FlexibleSpaceBar(
                        background: Container(
                          decoration: BoxDecoration(
                            gradient: wattGradient,
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 60,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 64),
                                Text(
                                  'Bookings',
                                  style: TextStyle(
                                    color: context.theme.appColors.background,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 28,
                                  ),
                                ),
                                Text(
                                  'Here you can see all bookings of your charger',
                                  style: TextStyle(
                                    color: context.theme.appColors.background,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 15,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      leading: BackButton(
                        color: context.theme.appColors.background,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      pinned: true,
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                    ),
                  ],
                ),
                Positioned(
                  top: 210,
                  left: 0,
                  right: 0,
                  child: Container(
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
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: SizedBox(
                            height: 64.0,
                            child: TabBar(
                              onTap: (index) {
                                if (index == 0) {
                                  print("Switching to Upcoming");
                                } else {
                                  print("Switching to Past");
                                }
                              },
                              tabAlignment: TabAlignment.fill,
                              labelColor: context.theme.appColors.primary,
                              unselectedLabelColor:
                                  context.theme.appColors.grey1,
                              indicatorColor: const Color(0xFF007AFF),
                              indicatorWeight: 2.0,
                              dividerColor: context.theme.appColors.grey1,
                              indicatorSize: TabBarIndicatorSize.tab,
                              labelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              unselectedLabelStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              tabs: const [
                                Tab(child: Text('Upcoming')),
                                Tab(child: Text('Past')),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: TabBarView(
                            children: [
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                itemCount: 1,
                                itemBuilder: (context, index) {
                                  return BookingCardWidget();
                                },
                              ),
                              ListView.builder(
                                padding: const EdgeInsets.only(top: 20),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return PastBookingCardWidget(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              PastBookingDetailsPage(),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
