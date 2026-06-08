import 'dart:convert';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:watt/data/keys/api_keys.dart';
import 'package:watt/utils/global_methods/google_maps_helper_methods.dart';

class LocationResult {
  final Position position;
  final String address;

  LocationResult(this.position, this.address);
}

class GoogleMapsRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<String>> fetchSuggestions(String input) async {
    String apiKey = ApiKeys.iosApiKey;

    if (Platform.isAndroid) {
      apiKey = ApiKeys.androidApiKey;
    } else if (Platform.isIOS) {
      apiKey = ApiKeys.iosApiKey;
    } else {
      print("Unsupported platform");
      apiKey = "No API key available";
    }

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=$input"
        "&key=$apiKey";

    try {
      final response = await http.get(Uri.parse(url));
      final data = json.decode(response.body);

      print("Status: ${data['status']}"); // ← check this first

      if (data['status'] != 'OK') {
        print("Error: ${data['error_message'] ?? 'No error message'}");
        return [];
      }

      return (data["predictions"] as List)
          .map<String>((p) => p["description"])
          .toList();
    } catch (e) {
      print("Exception: $e");
      return [];
    }
  }

  Future<bool> getLocationPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }

    return true;
  }

  Future<Position?> goToMyLocation() async {
    const LocationSettings locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
    );

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );

    return position;
  }

  Future<LocationResult?> searchLocation({
    required String address,
    required GoogleMapController? mapController,
  }) async {
    if (address.isEmpty) return null;

    try {
      List<Location> locations = await locationFromAddress(address);

      if (locations.isNotEmpty) {
        Location result = locations.first;
        LatLng targetLatLng = LatLng(result.latitude, result.longitude);

        List<Placemark> placemarks = await placemarkFromCoordinates(
          result.latitude,
          result.longitude,
        );

        final Position position = Position(
          longitude: result.longitude,
          latitude: result.latitude,
          timestamp: DateTime.now(),
          accuracy: 0.0,
          altitude: 0.0,
          altitudeAccuracy: 0.0,
          heading: 0.0,
          headingAccuracy: 0.0,
          speed: 0.0,
          speedAccuracy: 0.0,
        );

        String cleanAddress = address;

        if (placemarks.isNotEmpty) {
          final p = placemarks.first;
          cleanAddress = "${p.street}, ${p.locality}, ${p.country}";
        }

        LocationResult locationResult = LocationResult(position, cleanAddress);

        mapController?.animateCamera(
          CameraUpdate.newLatLngZoom(targetLatLng, 15),
        );
        return locationResult;
      }
    } catch (e) {
      print("Error finding location: $e");
    }
    return null;
  }

  Future<String?> handleMapTap({
    required LatLng tappedPoint,
  }) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        tappedPoint.latitude,
        tappedPoint.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;
        return "${place.street}, ${place.locality}";
      }
    } catch (e) {
      print("Could not find address for this point: $e");
    }
    return null;
  }

  Future<LocationResult?> chooseLocationOnMap() async {
    //Extracting city location
    final position = await goToMyLocation();

    if (position == null) return null;

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    String formattedAddress = "";

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      final city = place.locality ?? "";
      final country = place.country ?? "";

      formattedAddress = "$city, $country";
    }

    final convertedPosition =
        await GoogleMapsHelperMethods.convertAddressToPosition(
          formattedAddress,
        );

    final resultPosition = Position(
      longitude: convertedPosition?.longitude ?? 0.0,
      latitude: convertedPosition?.latitude ?? 0.0,
      timestamp: DateTime.now(),
      accuracy: 0.0,
      altitude: 0.0,
      altitudeAccuracy: 0.0,
      heading: 0.0,
      headingAccuracy: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
    );

    return LocationResult(resultPosition, formattedAddress);
  }

  Future<double?> getDistanceTo({
    required Position? myLocation,
    required double targetLatitude,
    required double targetLongitude,
  }) async {
    if (myLocation == null) return null;

    final distanceInMeters = Geolocator.distanceBetween(
      myLocation.latitude,
      myLocation.longitude,
      targetLatitude,
      targetLongitude,
    );

    return distanceInMeters / 1000;
  }
}
