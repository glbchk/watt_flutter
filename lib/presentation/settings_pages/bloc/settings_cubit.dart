import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watt/presentation/settings_pages/bloc/settings_state.dart';

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit() : super(SettingsState(isUserAuthenticated: false));
}
