import 'package:bloc_test/bloc_test.dart';
import 'package:candy_core/candy_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';

class MockInternetConnectionService extends Mock
    implements InternetConnectionService {}

InternetConnectionCubit _buildInternetConnectionCubitWithMockInternetService({
  bool isOffline = false,
  Stream<InternetConnectionStatus>? stream,
}) {
  final mockInternetService = MockInternetConnectionService();
  when(() => mockInternetService.onConnectionStatusChange).thenAnswer(
    (_) => stream ?? Stream.empty(),
  );

  when(() => mockInternetService.isOffline).thenAnswer(
    (_) async => isOffline,
  );
  return InternetConnectionCubit(mockInternetService);
}

void main() {
  blocTest<InternetConnectionCubit, InternetConnectionState>(
    'Initial State is emitted upon creation',
    build: () => _buildInternetConnectionCubitWithMockInternetService(),
    verify: (bloc) => expect(bloc.state, InternetConnectionState.initial()),
  );

  blocTest<InternetConnectionCubit, InternetConnectionState>(
    'onInitialize returns connected if initially connected',
    build: () => _buildInternetConnectionCubitWithMockInternetService(),
    act: (bloc) => bloc.initialize(),
    expect: () => const [InternetConnectionState.connected()],
  );

  blocTest<InternetConnectionCubit, InternetConnectionState>(
    'onInitialize returns disconnected if initially disconnected',
    build: () =>
        _buildInternetConnectionCubitWithMockInternetService(isOffline: true),
    act: (bloc) => bloc.initialize(),
    expect: () => const [InternetConnectionState.disconnected()],
  );

  blocTest<InternetConnectionCubit, InternetConnectionState>(
    'InternetConnectionState reacts to connection status changes',
    build: () => _buildInternetConnectionCubitWithMockInternetService(
        stream: Stream<InternetConnectionStatus>.fromIterable([
      InternetConnectionStatus.connected,
      InternetConnectionStatus.disconnected,
      InternetConnectionStatus.connected
    ])),
    expect: () => const [
      InternetConnectionState.connected(),
      InternetConnectionState.disconnected(),
      InternetConnectionState.connected(),
    ],
  );
}
