import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:watt/presentation/pages/login_page.dart';

import 'firebase_options.dart';
import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
      home: LoginPage(),
      // home: const LoginPage(),
    );
  }
}
