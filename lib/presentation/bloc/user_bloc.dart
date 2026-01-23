import 'package:bloc/bloc.dart';
import 'package:watt/domain/entities/user_entity.dart';
import 'package:watt/domain/use_cases/get_user_usecase.dart';
import 'package:watt/presentation/bloc/user_event.dart';
import 'package:watt/presentation/bloc/user_state.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final GetCurrentUserUseCase getCurrentUserUseCase;

  UserBloc(this.getCurrentUserUseCase)
    : super(
        UserInitial(
          UserEntity(
            id: '131425',
            name: 'John Doe',
            email: 'peterwatt@amp.com',
            phoneNumber: '+46 73 53 56 999',
            language: 'Ukrainian',
            paymentMethods: [],
            cars: [],
            chargingStations: [],
          ),
        ),
      );

  @override
  Stream<UserState> mapEventToState(UserEvent event) async* {
    if (event is GetCurrentUserEvent) {
      yield UserLoading();
      print('Event received: $event');
      try {
        final user = await getCurrentUserUseCase.execute(event.userId);
        yield UserLoaded(user);
        print('Event received: $event');
      } catch (e) {
        yield UserError("Couldn't fetch user");
        print('Event received: $event');
      }
    }
  }
}
