abstract class UserEvent {}

//create user

class GetCurrentUserEvent extends UserEvent {
  final String userId;

  GetCurrentUserEvent(this.userId);
}

//change user

//remove user
