import 'package:watt/domain/entities/user_entity.dart';

abstract class UserState {}

class UserInitial extends UserState {
  final UserEntity user;

  UserInitial(this.user);
}

class UserLoading extends UserState {}

class UserLoaded extends UserState {
  final UserEntity user;

  UserLoaded(this.user);
}

class UserError extends UserState {
  final String message;

  UserError(this.message);
}
