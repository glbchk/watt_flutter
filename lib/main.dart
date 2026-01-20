import 'package:flutter/material.dart';
import 'package:watt/pages/login_page.dart';

import 'data/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Watt App',
      theme: ThemeData(
        colorScheme: wattColorScheme,
        brightness: wattColorScheme.brightness,
      ),
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
    );
  }
}
