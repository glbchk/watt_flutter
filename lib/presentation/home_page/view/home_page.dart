import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/data/models/charging_station_model.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/presentation/home_page/view/components/app_drawer_widget.dart';
import 'package:watt/presentation/settings_pages/profile_page/profile_page.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';
import 'package:watt/utils/global_components/map_popup_widget.dart';
import 'package:watt/utils/global_components/search_bar_widget.dart';

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
    zoom: 14,
  );

  GoogleMapController? _mapController;

  Set<Marker> _markers = {};

  Future<void> generateMarkers(List<ChargingStationModel> stations) async {
    final markers = await buildMarkers(stations);

    setState(() {
      _markers = markers;
    });
  }

  Future<Set<Marker>> buildMarkers(List<ChargingStationModel> locations) async {
    final Set<Marker> markers = {};

    for (final location in locations) {
      markers.add(
        Marker(
          markerId: MarkerId(location.id),
          position: LatLng(
            location.addressLatitude ?? 0.0,
            location.addressLongitude ?? 0.0,
          ),
          infoWindow: InfoWindow(
            title: location.chargingStationName,
            snippet: location.address,
          ),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => MapPopupWidget(),
              ),
            );
          },
        ),
      );
    }

    return markers;
  }

  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().fetchMockedChargingStations();
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
      },
      builder: (context, state) {
        if (state.chargingStationsOnMap != null) {
          generateMarkers(state.chargingStationsOnMap ?? []);
        }

        final suggestions = state.locationSuggestions ?? [];

        return DefaultAppBar(
          showAppBar: false,
          resizeToAvoidBottomInset: false,
          extendBodyBehindAppBar: true,
          scaffoldBackgroundColor: context.theme.appColors.transparent,
          drawer: AppDrawer(
            onPressedLogout: () {
              context.read<HomeCubit>().logout();
            },
            onPressedProfile: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(),
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
                        // if (state.address != null)
                        Expanded(
                          child: MapPopupWidget(
                            chargingStationName: 'Save',
                            timeAvailability: 'Save',
                            chargingStationAddress: 'Save',
                            distanceToChargingStation: 'Save',
                            plugType: 'Save',
                            chargingEffect: 'Save',
                            pricePerKwh: 'Save',
                            onPressedMoreDetails: () {},
                            onPressedToBook: () {
                              // context.read<ChargingStationBloc>().add(
                              //   SaveAddressPropertyEvent(
                              //     state.address ?? "",
                              //     state.addressPosition,
                              //   ),
                              // );
                              // searchController.clear();
                              Navigator.pop(context);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

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
              //           // if (state.address != null)
              //           Expanded(
              //             child: MapPopupWidget(
              //               label: 'Save',
              //               onPressed: () {
              //                 // context.read<ChargingStationBloc>().add(
              //                 //   SaveAddressPropertyEvent(
              //                 //     state.address ?? "",
              //                 //     state.addressPosition,
              //                 //   ),
              //                 // );
              //                 // searchController.clear();
              //                 Navigator.pop(context);
              //               },
              //             ),
              //           ),
              //           const SizedBox(width: 15),
              //           Container(
              //             decoration: BoxDecoration(
              //               color: context.theme.appColors.background,
              //               borderRadius: BorderRadius.circular(30),
              //               boxShadow: [
              //                 BoxShadow(
              //                   color: context.theme.appColors.onSecondary
              //                       .withAlpha(
              //                         38,
              //                       ),
              //                   spreadRadius: 0,
              //                   blurRadius: 15,
              //                   offset: Offset(0, 4),
              //                 ),
              //               ],
              //             ),
              //             child: ClipRRect(
              //               borderRadius: BorderRadiusGeometry.circular(5),
              //               child: IconButton(
              //                 icon: const Icon(Icons.my_location),
              //                 onPressed: () {
              //                   context.read<HomeCubit>().logout();
              //                   // context.read<ChargingStationBloc>().add(
              //                   //   GoToMyLocationEvent(),
              //                   // );
              //
              //                   // Future.delayed(
              //                   //   const Duration(milliseconds: 100),
              //                   //   () {
              //                   //     _mapController?.showMarkerInfoWindow(
              //                   //       const MarkerId('selected_point'),
              //                   //     );
              //                   //   },
              //                   // );
              //                 },
              //               ),
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ),
              // ),
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
