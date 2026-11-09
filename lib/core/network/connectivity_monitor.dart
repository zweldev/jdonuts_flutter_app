import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class ConnectivityMonitor extends ChangeNotifier {
  ConnectivityMonitor({
    Connectivity? connectivity,
    Future<bool> Function()? reachabilityCheck,
  }) : _connectivity = connectivity ?? Connectivity(),
       _reachabilityCheck = reachabilityCheck ?? _checkInternetReachability {
    _subscription = _connectivity.onConnectivityChanged.listen(
      (_) => refresh(),
      onError: (Object error, StackTrace stackTrace) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stackTrace,
            library: 'connectivity monitoring',
          ),
        );
      },
    );
    unawaited(refresh());
  }

  final Connectivity _connectivity;
  final Future<bool> Function() _reachabilityCheck;
  late final StreamSubscription<List<ConnectivityResult>> _subscription;
  bool _isOnline = true;
  bool _refreshing = false;

  bool get isOnline => _isOnline;

  Future<void> refresh() async {
    if (_refreshing) return;
    _refreshing = true;
    try {
      final results = await _connectivity.checkConnectivity();
      final hasConnection = results.any(
        (result) => result != ConnectivityResult.none,
      );
      final online = hasConnection && await _reachabilityCheck();
      if (_isOnline != online) {
        _isOnline = online;
        notifyListeners();
      }
    } catch (error, stackTrace) {
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stackTrace,
          library: 'connectivity reachability check',
        ),
      );
      if (_isOnline) {
        _isOnline = false;
        notifyListeners();
      }
    } finally {
      _refreshing = false;
    }
  }

  static Future<bool> _checkInternetReachability() async {
    final client = HttpClient()..connectionTimeout = const Duration(seconds: 3);
    try {
      final request = await client
          .getUrl(Uri.https('connectivitycheck.gstatic.com', 'generate_204'))
          .timeout(const Duration(seconds: 4));
      final response = await request.close().timeout(
        const Duration(seconds: 4),
      );
      return response.statusCode == HttpStatus.noContent;
    } on SocketException {
      return false;
    } on HttpException {
      return false;
    } on TimeoutException {
      return false;
    } finally {
      client.close(force: true);
    }
  }

  @override
  void dispose() {
    unawaited(_subscription.cancel());
    super.dispose();
  }
}
