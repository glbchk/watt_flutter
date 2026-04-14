import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/settings_pages/bookings_page/components/booking_card_widget.dart';
import 'package:watt/presentation/settings_pages/bookings_page/components/past_booking_card_widget.dart';
import 'package:watt/presentation/settings_pages/bookings_page/sub_pages/past_booking_details_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_reservations_page/bloc/reservations_cubit.dart';
import 'package:watt/presentation/settings_pages/my_charging_reservations_page/bloc/reservations_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';

class MyReservationsPage extends StatefulWidget {
  const MyReservationsPage({super.key});

  @override
  State<MyReservationsPage> createState() => _MyReservationsPageState();
}

class _MyReservationsPageState extends State<MyReservationsPage> {
  @override
  void initState() {
    super.initState();

    context.read<ReservationsCubit>().fetchUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservationsCubit, ReservationsState>(
      builder: (context, state) {
        print(state.userData?.name);
        print(state.userData?.email);
        print(state.userData);

        final bookings = state.userData?.bookings;

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
                                  'My charging reservations',
                                  style: TextStyle(
                                    color: context.theme.appColors.background,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 26,
                                  ),
                                ),
                                Text(
                                  'Here you can see all your chargings',
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
                                itemCount: bookings?.length,
                                itemBuilder: (context, index) {
                                  final booking = bookings?[index];
                                  final selectedTime =
                                      bookings?[index].selectedTimes;
                                  print(booking?.station?.chargingStationName);

                                  return BookingCardWidget(
                                    chargingStationName:
                                        booking?.station?.chargingStationName,
                                    dateOfBooking: booking?.date,
                                    chargingStationTimeSlot:
                                        "${selectedTime?.first.startTime}-${selectedTime?.first.endTime}",
                                    chargingStationAddress:
                                        booking?.station?.address,
                                    onPressedReject: () {},
                                    onPressedAccept: () {},
                                    onPressedContactUser: () {},
                                  );
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
