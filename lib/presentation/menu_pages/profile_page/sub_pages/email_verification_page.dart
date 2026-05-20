import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_cubit.dart';
import 'package:watt/presentation/menu_pages/profile_page/bloc/profile_state.dart';
import 'package:watt/utils/global_components/watt_main_button.dart';

class EmailVerificationPage extends StatefulWidget {
  final String pendingEmail;
  const EmailVerificationPage({super.key, required this.pendingEmail});

  @override
  State<EmailVerificationPage> createState() => _EmailVerificationPageState();
}

class _EmailVerificationPageState extends State<EmailVerificationPage> {
  Timer? _pollingTimer;

  @override
  void initState() {
    super.initState();

    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      context.read<ProfileCubit>().checkVerificationEmailAndUpdate(
        widget.pendingEmail,
      );
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.isEmailVerified == true) {
          _pollingTimer?.cancel();

          Navigator.of(context).pop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text('We sent you a verification link!'),
                const SizedBox(height: 20),
                const CircularProgressIndicator(),
                const SizedBox(height: 20),
                WattMainButton(
                  label: 'Resend Email',
                  onPressed: () {
                    context.read<ProfileCubit>().sendVerificationEmail();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
