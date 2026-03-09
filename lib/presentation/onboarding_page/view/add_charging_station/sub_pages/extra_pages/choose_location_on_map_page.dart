import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/global_components/default_app_bar.dart';

class ChooseLocationOnMapPage extends StatefulWidget {
  const ChooseLocationOnMapPage({super.key});

  @override
  State<ChooseLocationOnMapPage> createState() =>
      _ChooseLocationOnMapPageState();
}

class _ChooseLocationOnMapPageState extends State<ChooseLocationOnMapPage> {
  TextEditingController searchController = TextEditingController();

  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(51.5074, -0.1278), // Example: London
    zoom: 12,
  );

  GoogleMapController? _mapController;

  LatLng? _selectedLocation;

  String address = '';

  void _handleMapTap(LatLng tappedPoint) async {
    setState(() {
      _selectedLocation = tappedPoint;
    });

    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        tappedPoint.latitude,
        tappedPoint.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        address = "${place.street}, ${place.locality}";
        searchController.text = address;
        print("User tapped on: $address");

        // You could update a TextField or show a BottomSheet here
      }
    } catch (e) {
      print("Could not find address for this point.");
    }
  }

  Future<void> _goToMyLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return;
    }

    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(position.latitude, position.longitude),
        15,
      ),
    );
  }

  Widget _buildSearchBar() {
    return Row(
      children: [
        Container(
          decoration: BoxDecoration(
            color: context.theme.appColors.background,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: context.theme.appColors.onSecondary.withAlpha(38),
                spreadRadius: 0,
                blurRadius: 15,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadiusGeometry.circular(5),
            child: IconButton(
              icon: const Icon(Icons.arrow_back_ios_new),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ),

        const SizedBox(width: 16),

        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: context.theme.appColors.background,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: context.theme.appColors.onSecondary.withAlpha(38),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(Icons.search),

                const SizedBox(width: 10),

                Expanded(
                  child: TextField(
                    controller: searchController,
                    decoration: const InputDecoration(
                      hintText: "Search location",
                      border: InputBorder.none,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _goToMyLocation,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: DefaultAppBar(
        resizeToAvoidBottomInset: true,
        extendBodyBehindAppBar: true,
        appBarBackgroundColor: context.theme.appColors.transparent,

        body: Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialPosition,
              mapType: MapType.normal,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              onTap: _handleMapTap,

              gestureRecognizers: {
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },

              onMapCreated: (GoogleMapController controller) async {
                _mapController = controller;
                await _goToMyLocation();
              },
              markers: _selectedLocation == null
                  ? {}
                  : {
                      Marker(
                        markerId: const MarkerId('selected_point'),
                        position: _selectedLocation!,
                        infoWindow: const InfoWindow(
                          title: 'Selected Location',
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueAzure,
                        ),
                      ),
                    },
            ),

            Positioned(
              top: MediaQuery.of(context).padding.top,
              left: 20,
              right: 20,
              child: _buildSearchBar(),
            ),
          ],
        ),
        floatingActionButton: Container(
          decoration: BoxDecoration(
            color: context.theme.appColors.background,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: context.theme.appColors.onSecondary.withAlpha(38),
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
              onPressed: _goToMyLocation,
            ),
          ),
        ),
      ),
    );
  }
}
