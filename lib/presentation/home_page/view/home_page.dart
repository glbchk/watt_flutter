import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:share_plus/share_plus.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/view/auth_page.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/home_page/view/components/app_drawer_widget.dart';
import 'package:watt/presentation/home_page/view/sub_pages/stages/reservation_booking_page.dart';
import 'package:watt/presentation/settings_pages/bookings_page/bookings_page.dart';
import 'package:watt/presentation/settings_pages/cars_page/my_cars_page.dart';
import 'package:watt/presentation/settings_pages/help_page/help_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_reservations_page/my_reservations_page.dart';
import 'package:watt/presentation/settings_pages/my_charging_stations_page/my_charging_stations_page.dart';
import 'package:watt/presentation/settings_pages/my_payment_methods_page/my_payment_methods_page.dart';
import 'package:watt/presentation/settings_pages/profile_page/profile_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/map_popup_widget.dart';
import 'package:watt/utils/global_components/search_bar_widget.dart';
import 'package:watt/utils/global_methods/google_maps_helper_methods.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TextEditingController searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  bool showSuggestions = false;

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(52.157902, -106.6701577), // Example: Saskatoon
    zoom: 13,
  );

  GoogleMapController? _mapController;

  Set<Marker> _markers = {};

  Future<void> generateMarkers(
    List<ChargingStationModel> stations,
  ) async {
    final markers = buildMarkers(stations);

    setState(() {
      _markers = markers;
    });
  }

  Set<Marker> buildMarkers(List<ChargingStationModel> locations) {
    final Set<Marker> markers = {};
    final state = context.read<HomeCubit>().state;

    for (final location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: LatLng(
            location.addressLatitude ?? 0.0,
            location.addressLongitude ?? 0.0,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            GoogleMapsHelperMethods.getMarkerHue(
              stationId: location.id,
              userIds: state.userStationIds,
              type: location.type ?? ChargingStationType.private,
            ),
          ),
          onTap: () async {
            await context.read<HomeCubit>().getDistanceToChargingStation(
              location.addressLatitude ?? 0.0,
              location.addressLongitude ?? 0.0,
            );

            if (!context.mounted) return;

            final double? distanceKm = context
                .read<HomeCubit>()
                .state
                .stationDistance;

            if (distanceKm != null) {
              final latLng = LatLng(
                location.addressLatitude ?? 0.0,
                location.addressLongitude ?? 0.0,
              );

              _mapController?.animateCamera(
                CameraUpdate.newLatLngZoom(latLng, 15),
              );
            }

            if (location.type == ChargingStationType.private) {
              print(location.stationStatus?.label);
              MapPopupWidget.show(
                context: context,
                station: location,
                onPressedMoreDetails: () {
                  // context.read<HomeCubit>().bookingStage();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReservationBookingPage(
                        stationId: location.id,
                      ),
                    ),
                  );
                },
                onPressedToBook: () {
                  // context.read<HomeCubit>().bookingStage();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReservationBookingPage(
                        stationId: location.id,
                      ),
                    ),
                  );
                },
                distanceToChargingStation: distanceKm != null
                    ? '${distanceKm.toStringAsFixed(2)} km'
                    : 'Unknown',
                stationStatus: location.stationStatus?.label,
              );
            } else {
              print(location.stationStatus?.label);
              MapPopupWidget.show(
                context: context,
                station: location,
                onPressedPublicCharger: () {
                  context.read<HomeCubit>().publicChargerStage();
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ReservationBookingPage(
                        stationId: location.id,
                      ),
                    ),
                  );
                },
                distanceToChargingStation: distanceKm != null
                    ? '${distanceKm.toStringAsFixed(2)} km'
                    : 'Unknown',
                stationStatus: location.stationStatus?.label,
              );
            }
          },
        ),
      );
    }

    return markers;
  }

  Future<void> _initHome() async {
    await context.read<HomeCubit>().fetchUserData();
    if (!mounted) return;
    await context.read<HomeCubit>().getLocationPermission();
    if (!mounted) return;
    await context.read<HomeCubit>().seedMockedChargingStations();
  }

  @override
  void initState() {
    super.initState();

    _initHome();
  }

  @override
  void dispose() {
    searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeCubit, HomeState>(
      listener: (context, state) {
        if (!state.isUserAuthenticated) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => AuthPage()),
            (route) => false,
          );
        }

        if (state.chargingStationsOnMap != null) {
          generateMarkers(state.chargingStationsOnMap ?? []);
        }

        if (state.address != null) {
          final latLng = LatLng(
            state.addressLatitude ?? 0.0,
            state.addressLongitude ?? 0.0,
          );

          if (searchController.text != state.address) {
            searchController.text = state.address ?? "";
            searchController.selection = TextSelection.fromPosition(
              TextPosition(offset: searchController.text.length),
            );
          }

          if (_mapController != null) {
            _mapController
                ?.animateCamera(
                  CameraUpdate.newLatLngZoom(latLng, 15),
                )
                .then((_) {
                  Future.delayed(const Duration(milliseconds: 300), () {
                    _mapController?.showMarkerInfoWindow(
                      const MarkerId('selected_point'),
                    );
                  });
                });
          }
        }

        // if (state.myLocation != null && state.stationDistance != null) {
        //   final latLng = LatLng(
        //     state.myLocation!.latitude,
        //     state.myLocation!.longitude,
        //   );
        //
        //   _mapController?.animateCamera(
        //     CameraUpdate.newLatLngZoom(latLng, 15),
        //   );
        // }
      },
      builder: (context, state) {
        final suggestions = state.locationSuggestions ?? [];

        final user = state.userData;

        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return DefaultAppBar(
          showAppBar: false,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          scaffoldBackgroundColor: context.theme.appColors.transparent,
          drawer: AppDrawer(
            name: (user?.name != null && user!.name!.isNotEmpty)
                ? user.name
                : 'Name not found',
            email: (user?.email != null && user!.email!.isNotEmpty)
                ? user.email
                : 'Email not found',
            onPressedLogout: () {
              context.read<AuthBloc>().add(LogoutRequestedEvent());
            },
            onPressedProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
                ),
              );
            },
            onPressedBookings: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyBookingsPage(),
                ),
              );
            },
            onPressedMyChargings: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyReservationsPage(),
                ),
              );
            },
            onPressedMyCars: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyCarsPage(
                    // car: CarModel(
                    //   id: '141',
                    //   plateNumber: 'AAA111',
                    //   brandName: KMockedData.cars[2].name,
                    //   carModel: 'Model S',
                    //   brandLogo: KMockedData.cars[2].logo,
                    // ),
                  ),
                ),
              );
            },
            onPressedYourCharger: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyChargingStationsPage(),
                ),
              );
            },
            onPressedPaymentMethod: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MyPaymentMethodsPage(),
                ),
              );
            },
            onPressedInviteFriends: () async {
              await SharePlus.instance.share(
                ShareParams(
                  text:
                      "Join Watt! Charging stations are waiting for your EV ⚡\n\n${context.read<HomeCubit>().inviteFriends()}",
                ),
              );
            },
            onPressedHelp: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HelpPage(),
                ),
              );
            },
          ),

          drawerScrimColor: Colors.black.withValues(alpha: 0.3),
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: state.address != null
                    ? CameraPosition(
                        target: LatLng(
                          state.addressLatitude ?? 0.0,
                          state.addressLongitude ?? 0.0,
                        ),
                        zoom: 15,
                      )
                    : _initialPosition,
                mapType: MapType.normal,
                myLocationEnabled: state.isLocationEnabled ?? false,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                onTap: (LatLng tappedPoint) async {
                  // context.read<HomeCubit>().add(
                  //   HandleMapTapEvent(tappedPoint),
                  // );
                },

                onMapCreated: (GoogleMapController controller) async {
                  _mapController = controller;

                  if (state.isLocationEnabled == true) {
                    // context.read<ChargingStationBloc>().add(
                    //   GoToMyLocationEvent(),
                    // );
                  }
                },
                markers: _markers,
                // markers: state.addressPosition == null ? {} : _markers,

                // Marker(
                //   markerId: const MarkerId('selected_point'),
                //   position: LatLng(
                //     state.addressPosition?.latitude ?? 0.0,
                //     state.addressPosition?.longitude ?? 0.0,
                //   ),
                //   infoWindow: InfoWindow(
                //     title: state.address,
                //   ),
                //   icon: BitmapDescriptor.defaultMarkerWithHue(
                //     BitmapDescriptor.hueAzure,
                //   ),
                // ),
              ),

              // if (state.address != null)
              // Positioned(
              //   bottom: 0,
              //   left: 0,
              //   right: 0,
              //   child: SafeArea(
              //     child: Padding(
              //       padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.end,
              //         children: [
              //         ...stations.map((station) {
              //           return MapPopupWidget.show(context: context, station: station),
              //           );}).toList(),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: context.theme.appColors.background,
                            borderRadius: BorderRadius.circular(30),
                            boxShadow: [
                              BoxShadow(
                                color: context.theme.appColors.onSecondary
                                    .withAlpha(
                                      38,
                                    ),
                                spreadRadius: 0,
                                blurRadius: 15,
                                offset: Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadiusGeometry.circular(5),
                            child: IconButton(
                              icon: const Icon(Icons.my_location),
                              onPressed: () async {
                                await context
                                    .read<HomeCubit>()
                                    .goToMyLocation();

                                final myLocation = context
                                    .read<HomeCubit>()
                                    .state
                                    .myLocation;

                                if (myLocation != null) {
                                  final latLng = LatLng(
                                    myLocation.latitude,
                                    myLocation.longitude,
                                  );

                                  _mapController?.animateCamera(
                                    CameraUpdate.newLatLngZoom(latLng, 15),
                                  );
                                }
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: MediaQuery.of(context).viewPadding.top + 75,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: () {
                    _focusNode.unfocus();
                  },
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
              ),

              Positioned(
                top: MediaQuery.of(context).viewPadding.top,
                left: 20,
                right: 20,
                child: Column(
                  children: [
                    Builder(
                      builder: (innerContext) {
                        return SearchBarWidget(
                          leadingIcon: Icon(Icons.menu),
                          onLeadingPressed: () {
                            Scaffold.of(innerContext).openDrawer();
                          },
                          context: context,
                          focusNode: _focusNode,
                          onFocusChange: (hasFocus) {
                            setState(() {
                              showSuggestions = hasFocus;
                            });
                          },

                          controller: searchController,
                          mapController: _mapController,
                          onChanged: (value) {
                            // context.read<ChargingStationBloc>().add(
                            //   FetchLocationSuggestionsEvent(value),
                            // );
                          },
                          onIconPressed: () {
                            searchController.clear();
                            // context.read<ChargingStationBloc>().add(
                            //   ClearAddressPropertyEvent(),
                            // );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),

              if (showSuggestions && suggestions.isNotEmpty)
                Positioned(
                  top: 108,
                  left: 85,
                  right: 20,
                  child: Material(
                    elevation: 4,
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(10),
                    color: context.theme.appColors.surface,
                    child: Container(
                      constraints: const BoxConstraints(
                        maxHeight: 400,
                      ),
                      decoration: BoxDecoration(
                        color: context.theme.appColors.background,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        padding: EdgeInsets.zero,
                        itemCount: suggestions.length,
                        itemBuilder: (context, index) {
                          final suggestion = suggestions[index];

                          return ListTile(
                            leading: const Icon(
                              Icons.location_on_outlined,
                            ),
                            title: Text(suggestion),
                            onTap: () {
                              searchController.text = suggestion;
                              setState(() {
                                showSuggestions = false;
                              });
                              _focusNode.unfocus();

                              // context.read<ChargingStationBloc>().add(
                              //   SearchLocationEvent(
                              //     suggestion,
                              //     _mapController,
                              //   ),
                              // );
                            },
                          );
                        },
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
