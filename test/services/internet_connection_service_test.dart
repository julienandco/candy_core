import 'package:candy_core/candy_core.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class MockInternetConnectionChecker extends Mock
    implements InternetConnectionChecker {}

void main() {
  group('on MacOS or Web', () {
    test('internetConnectionChecker is null on MacOS or Web', () {
      final service = InternetConnectionService();
      // _mockInternetCheckerInitializationParam(
      //     service: service, isOnMacOsOrWeb: true);

      expect(service.internetConnectionChecker, isNull);
    });

    test('isOffline always returns false when on MacOS or Web', () {
      final service = InternetConnectionService();
      // _mockInternetCheckerInitializationParam(
      //     service: service, isOnMacOsOrWeb: true);

      service.isOffline.then((value) => expect(value, isFalse));
    });

    test(
        'onConnectionStatusChange returns constant Connected Stream when on MacOS or Web',
        () {
      final service = InternetConnectionService();
      // _mockInternetCheckerInitializationParam(
      //     service: service, isOnMacOsOrWeb: true);
      final stream = service.onConnectionStatusChange;

      expect(stream, emits(InternetConnectionStatus.connected));
    });
  });

  group('not on MacOS or Web', () {
    test('internetConnectionChecker is initialized when not on MacOS or Web',
        () {
      final service = InternetConnectionService(isMockWebOrMacOS: false);

      expect(
          service.internetConnectionChecker, isA<InternetConnectionChecker>());
      expect(service.internetConnectionChecker, isNotNull);
    });

    test('isOffline depends on connection status when not on MacOS or Web', () {
      final mockChecker = MockInternetConnectionChecker();
      when(() => mockChecker.connectionStatus)
          .thenAnswer((_) async => InternetConnectionStatus.disconnected);
      final service = InternetConnectionService(isMockWebOrMacOS: false);

      service.internetConnectionChecker = mockChecker;

      service.isOffline.then((value) => expect(value, true));
    });

    test(
        'onConnectionStatusChange returns the connection Checker Stream when not on MacOS or Web',
        () async {
      final service = InternetConnectionService(isMockWebOrMacOS: false);

      final mockChecker = MockInternetConnectionChecker();
      final statusList = [
        InternetConnectionStatus.disconnected,
        InternetConnectionStatus.disconnected,
        InternetConnectionStatus.connected,
        InternetConnectionStatus.disconnected,
        InternetConnectionStatus.connected,
      ];

      when(() => mockChecker.onStatusChange)
          .thenAnswer((_) => Stream.fromIterable(statusList));

      service.internetConnectionChecker = mockChecker;
      final stream = service.onConnectionStatusChange;

      expect(stream, emitsInOrder(statusList));
    });
  });
}
