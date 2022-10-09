part of 'internet_connection_cubit.dart';

@freezed
class InternetConnectionState with _$InternetConnectionState {
  const factory InternetConnectionState.initial() = _InternetConnectionInitial;
  const factory InternetConnectionState.connected() =
      _InternetConnectionConnected;
  const factory InternetConnectionState.disconnected() =
      _InternetConnectionDisconnected;
}
