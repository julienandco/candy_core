import 'package:bloc/bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:candy_core/src/services/services.dart';

part 'internet_connection_state.dart';
part 'internet_connection_cubit.freezed.dart';

class InternetConnectionCubit extends Cubit<InternetConnectionState> {
  final InternetConnectionService internetConnectionService;

  InternetConnectionCubit(this.internetConnectionService)
      : super(
          const InternetConnectionState.initial(),
        ) {
    internetConnectionService.onConnectionStatusChange.listen((status) {
      if (status == InternetConnectionStatus.connected) {
        emit(const InternetConnectionState.connected());
      } else {
        emit(const InternetConnectionState.disconnected());
      }
    });
  }

  Future<void> initialize() async {
    final isOffline = await internetConnectionService.isOffline;
    isOffline
        ? emit(const InternetConnectionState.disconnected())
        : emit(const InternetConnectionState.connected());
  }
}
