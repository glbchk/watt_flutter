import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watt/presentation/auth_page/bloc/auth_bloc.dart';
import 'package:watt/presentation/auth_page/bloc/auth_event.dart';
import 'package:watt/presentation/auth_page/bloc/auth_state.dart';
import 'package:watt/presentation/auth_page/view/auth_page.dart';
import 'package:watt/presentation/home_page/view/home_page.dart';
import 'package:watt/presentation/menu_pages/bookings_page/bloc/bookings_cubit.dart';
import 'package:watt/presentation/onboarding_page/bloc/onboarding_bloc.dart';
import 'package:watt/utils/colors.dart';
import 'package:watt/utils/constants.dart';
import 'package:watt/utils/notifiers.dart';

import 'firebase_options.dart';
import 'presentation/home_page/bloc/home_cubit.dart';
import 'presentation/menu_pages/cars_page/bloc/my_cars_cubit.dart';
import 'presentation/menu_pages/my_charging_reservations_page/bloc/reservations_cubit.dart';
import 'presentation/menu_pages/my_charging_stations_page/bloc/my_charging_stations_cubit.dart';
import 'presentation/menu_pages/my_payment_methods_page/bloc/my_payment_methods_cubit.dart';
import 'presentation/menu_pages/profile_page/bloc/profile_cubit.dart';
import 'presentation/onboarding_page/view/add_charging_station/bloc/charging_station_bloc.dart';
import 'presentation/onboarding_page/view/add_payment_method/bloc/payment_method_bloc.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await initThemeMode();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc()..add(IsUserLoggedInAuthEvent()),
        ),
        BlocProvider<MyPaymentMethodsCubit>(
          create: (context) =>
              MyPaymentMethodsCubit(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<MyChargingStationsCubit>(
          create: (context) =>
              MyChargingStationsCubit(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<MyCarsCubit>(
          create: (context) => MyCarsCubit(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<ReservationsCubit>(
          create: (context) =>
              ReservationsCubit(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<BookingsCubit>(
          create: (context) =>
              BookingsCubit(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<ProfileCubit>(
          create: (context) => ProfileCubit(authBloc: context.read<AuthBloc>()),
        ),
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            authBloc: context.read<AuthBloc>(),
            profileCubit: context.read<ProfileCubit>(),
          ),
        ),

        BlocProvider(
          create: (context) => OnboardingBloc(),
        ),
        BlocProvider(
          create: (context) => ChargingStationBloc(),
        ),
        BlocProvider(
          create: (context) => PaymentMethodBloc(),
        ),
      ],
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
    return ValueListenableBuilder(
      valueListenable: isDarkModeNotifier,
      builder: (context, isDarkMode, child) {
        return MaterialApp(
          title: 'Watt App',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: BlocBuilder<AuthBloc, AuthState>(
            builder: (context, state) {
              if (state is AuthSuccessState) {
                return HomePage();
              } else {
                return AuthPage();
              }
            },
          ),
        );
      },
    );
  }
}

Future<void> initThemeMode() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final bool? repeat = prefs.getBool(KConstants.themeModeKey);
  isDarkModeNotifier.value = repeat ?? false;
}
