import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/data/data_sources/user_remote_data_source.dart';
import 'package:watt/data/repositories/user_repository_impl.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/bloc/user_bloc.dart';
import 'package:watt/presentation/bloc/user_state.dart';

//TO BE DELETED PAGE, CREATED JUST FOR OVERVIEW PURPOSE

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: BlocProvider(
        create: (context) => UserBloc(
          GetCurrentUserUseCase(
            UserRepositoryImpl(
              UserRemoteDataSource(
                auth: FirebaseAuth.instance,
                firestore: FirebaseFirestore.instance,
              ),
            ),
          ),
        ),
        child: UserProfile(),
      ),
    );
  }
}

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (context, state) {
        if (state is UserInitial) {
          return Center(
            child: Column(
              children: [
                Text('ID: ${state.user.id}'),
                Text('Name: ${state.user.name}'),
                Text('Email: ${state.user.email}'),
                Text('Phone Number: ${state.user.phoneNumber}'),
                Text('Language: ${state.user.language}'),
              ],
            ),
          );

          // Text('Press the button to fetch user data.');
        } else if (state is UserLoading) {
          return Center(child: CircularProgressIndicator());
        } else if (state is UserLoaded) {
          return Column(
            children: [
              Text('ID: ${state.user.id}'),
              Text('Name: ${state.user.name}'),
              Text('Email: ${state.user.email}'),
              Text('Phone Number: ${state.user.phoneNumber}'),
              Text('Language: ${state.user.language}'),
            ],
          );
        } else if (state is UserError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}
