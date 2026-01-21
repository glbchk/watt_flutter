import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/data_sources/remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/use_cases/get_user_usecase.dart';
import '../bloc/user_bloc.dart';
import '../bloc/user_state.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('User Profile')),
      body: BlocProvider(
        create: (context) => UserBloc(
          GetCurrentUserUseCase(UserRepositoryImpl(RemoteDataSource())),
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
