import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/app_bloc_observer.dart';
import 'package:watt/domain/use_cases/get_auth_usecase.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/view/auth_page.dart';

import 'data/data_sources/auth_remote_data_source.dart';
import 'data/data_sources/user_remote_data_source.dart';
import 'data/repositories/auth_repository_impl.dart';
import 'firebase_options.dart';
import 'utils/colors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  Bloc.observer = AppBlocObserver();

  final authRepo = AuthRepositoryImpl(
    AuthRemoteDataSource(FirebaseAuth.instance),
    UserRemoteDataSource(
      auth: FirebaseAuth.instance,
      firestore: FirebaseFirestore.instance,
    ),
  );
  final registerUserUseCase = RegisterUserUseCase(authRepo);
  final loginUserUseCase = LoginUserUseCase(authRepo);
  final logoutUserUseCase = LogoutUserUseCase(authRepo);

  runApp(
    BlocProvider(
      create: (_) => AuthBloc(
        registerUserUseCase: registerUserUseCase,
        loginUserUseCase: loginUserUseCase,
        logoutUserUseCase: logoutUserUseCase,
      ),
      child: const MyApp(),
    ),
  );
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
      home: AuthPage(),
      // home: const LoginPage(),
    );
  }
}
