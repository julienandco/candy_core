import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import 'package:candy_core/src/util/helpers.dart';

class InternetConnectionService {
  InternetConnectionService({this.isMockWebOrMacOS}) : super() {
    if (!(isMockWebOrMacOS ?? kIsWebOrMacOS)) {
      internetConnectionChecker = InternetConnectionChecker();
    }
  }

  @visibleForTesting
  bool? isMockWebOrMacOS;

  @visibleForTesting
  InternetConnectionChecker? internetConnectionChecker;

  Stream<InternetConnectionStatus> get onConnectionStatusChange {
    if (isMockWebOrMacOS ?? kIsWebOrMacOS) {
      return Stream.value(InternetConnectionStatus.connected);
    }
    return internetConnectionChecker!.onStatusChange;
  }

  Future<bool> get isOffline async {
    if (isMockWebOrMacOS ?? kIsWebOrMacOS) return false;
    if (internetConnectionChecker == null) return true;
    final status = await internetConnectionChecker!.connectionStatus;
    return status == InternetConnectionStatus.disconnected;
  }
}
