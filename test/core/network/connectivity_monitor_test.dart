import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:jdonuts_flutter_app/core/network/connectivity_monitor.dart';

void main() {
  test(
    'uses reachability in addition to the network interface status',
    () async {
      final connectivity = _FakeConnectivity();
      addTearDown(connectivity.close);
      var internetReachable = true;
      final monitor = ConnectivityMonitor(
        connectivity: connectivity,
        reachabilityCheck: () async => internetReachable,
      );
      addTearDown(monitor.dispose);

      await Future<void>.delayed(const Duration(milliseconds: 10));
      expect(monitor.isOnline, isTrue);

      connectivity.status = [ConnectivityResult.none];
      await monitor.refresh();
      expect(monitor.isOnline, isFalse);

      connectivity.status = [ConnectivityResult.wifi];
      internetReachable = false;
      await monitor.refresh();
      expect(monitor.isOnline, isFalse);

      internetReachable = true;
      await monitor.refresh();
      expect(monitor.isOnline, isTrue);
    },
  );
}

class _FakeConnectivity implements Connectivity {
  final _changes = StreamController<List<ConnectivityResult>>.broadcast();
  List<ConnectivityResult> status = [ConnectivityResult.wifi];

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged => _changes.stream;

  @override
  Future<List<ConnectivityResult>> checkConnectivity() async => status;

  Future<void> close() => _changes.close();
}
