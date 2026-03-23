import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watt/presentation/auth_page/view/auth_page.dart';
import 'package:watt/presentation/home_page/bloc/home_cubit.dart';
import 'package:watt/presentation/home_page/bloc/home_state.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/notifiers.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  static const CameraPosition _initialPosition = CameraPosition(
    target: LatLng(51.5074, -0.1278), // Example: London
    zoom: 12,
  );

  GoogleMapController? _mapController;

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

  // Future<void> _searchAddress() async {
  //   String address = controllerAddress.text;
  //
  //   try {
  //     List<Location> locations = await locationFromAddress(address);
  //
  //     if (locations.isNotEmpty) {
  //       Location first = locations.first;
  //
  //       // 2. Move the camera to the found location
  //       _mapController?.animateCamera(
  //         CameraUpdate.newCameraPosition(
  //           CameraPosition(
  //             target: LatLng(first.latitude, first.longitude),
  //             zoom: 15,
  //           ),
  //         ),
  //       );
  //
  //       setState(() {
  //         // You can add a marker to your markers set here
  //       });
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text("Address not found")),
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocListener<HomeCubit, HomeState>(
      listener: (context, state) {
        if (state is AuthUnauthenticatedState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => AuthPage()),
          );
        }
        if (state is AuthErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
              onPressed: () async {
                isDarkModeNotifier.value = !isDarkModeNotifier.value;
                final SharedPreferences prefs =
                    await SharedPreferences.getInstance();
                await prefs.setBool(
                  KConstants.themeModeKey,
                  isDarkModeNotifier.value,
                );
              },
              icon: ValueListenableBuilder(
                valueListenable: isDarkModeNotifier,
                builder: (context, isDarkMode, child) {
                  return Icon(isDarkMode ? Icons.dark_mode : Icons.light_mode);
                },
              ),
            ),
            IconButton(
              onPressed: () {
                context.read<HomeCubit>().logout();
              },
              icon: Icon(Icons.logout),
            ),
          ],
        ),
        body: GoogleMap(
          initialCameraPosition: _initialPosition,
          mapType: MapType.normal,
          myLocationEnabled: true,
          myLocationButtonEnabled: false,
          onMapCreated: (GoogleMapController controller) async {
            _mapController = controller;
            await _goToMyLocation();
          },

          markers: {
            const Marker(
              markerId: MarkerId('default'),
              position: LatLng(59.3293, 18.0686),
              infoWindow: InfoWindow(title: 'Stockholm Center'),
            ),
          },
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
