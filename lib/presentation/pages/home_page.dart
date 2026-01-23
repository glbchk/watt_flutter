import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // static const CameraPosition _initialPosition = CameraPosition(
  //   target: LatLng(51.5074, -0.1278), // Example: London
  //   zoom: 12,
  // );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SizedBox.expand(
        child: Image.asset(
          'assets/images/map.png',
          fit: BoxFit.cover,
        ),
      ),
    );
    // return Scaffold(
    //   appBar: AppBar(),
    //   body: GoogleMap(
    //     initialCameraPosition: _initialPosition,
    //     myLocationEnabled: true,
    //     myLocationButtonEnabled: true,
    //   ),
    // );
  }
}
