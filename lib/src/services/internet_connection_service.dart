import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:candy_core/src/util/helpers.dart';

class InternetConnectionService {
  InternetConnectionService() : super() {
    if (!isWebOrMacOS) _internetConnectionChecker = InternetConnectionChecker();
  }
  InternetConnectionChecker? _internetConnectionChecker;

  Stream<InternetConnectionStatus> get onConnectionStatusChange {
    if (isWebOrMacOS) return Stream.value(InternetConnectionStatus.connected);
    return _internetConnectionChecker!.onStatusChange;
  }

  Future<bool> get isOffline async {
    if (isWebOrMacOS) return false;
    final status = await _internetConnectionChecker?.connectionStatus;
    return status == InternetConnectionStatus.disconnected;
  }
}
