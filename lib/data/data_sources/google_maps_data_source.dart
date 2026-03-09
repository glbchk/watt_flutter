import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class GoogleMapsRemoteDataSource {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Future<List<String>> fetchSuggestions(String input) async {
    const apiKey = "AIzaSyBFlWLbXlxy2nxw-561AW2k0ylfXIeB9I8";

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json"
        "?input=$input"
        "&key=$apiKey";

    final response = await http.get(Uri.parse(url));

    final data = json.decode(response.body);

    return (data["predictions"] as List)
        .map<String>((p) => p["description"])
        .toList();
  }

  // Future<UserModel> saveOnboardingDataForRegister(UserModel user) async {
  //   return user;
  // }
}
