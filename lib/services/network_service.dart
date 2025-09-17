import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
enum NetworkStatus { connected, disconnected, unknown }
class NetworkService {
  static final NetworkService _instance = NetworkService._internal();
  factory NetworkService() => _instance;
  NetworkService._internal();
  final StreamController<NetworkStatus> _networkStatusController =
      StreamController<NetworkStatus>.broadcast();
  Stream<NetworkStatus> get networkStatusStream =>
      _networkStatusController.stream;
  NetworkStatus _currentStatus = NetworkStatus.unknown;
  NetworkStatus get currentStatus => _currentStatus;
  StreamSubscription<InternetStatus>? _connectivitySubscription;
  void initialize() {
    _startNetworkMonitoring();
  }
  void _startNetworkMonitoring() {
    _connectivitySubscription = InternetConnection().onStatusChange.listen(
      (InternetStatus status) {
        final newStatus = _mapInternetStatusToNetworkStatus(status);
        if (newStatus != _currentStatus) {
          _currentStatus = newStatus;
          _networkStatusController.add(_currentStatus);
          if (kDebugMode) {
            print('Network status changed to: $newStatus');
          }
        }
      },
      onError: (error) {
        if (kDebugMode) {
          print('Network monitoring error: $error');
        }
        _currentStatus = NetworkStatus.unknown;
        _networkStatusController.add(_currentStatus);
      },
    );
    _checkConnectivity();
  }
  NetworkStatus _mapInternetStatusToNetworkStatus(InternetStatus status) {
    switch (status) {
      case InternetStatus.connected:
        return NetworkStatus.connected;
      case InternetStatus.disconnected:
        return NetworkStatus.disconnected;
    }
  }
  Future<void> _checkConnectivity() async {
    try {
      final hasConnection = await InternetConnection().hasInternetAccess;
      final newStatus = hasConnection
          ? NetworkStatus.connected
          : NetworkStatus.disconnected;
      if (newStatus != _currentStatus) {
        _currentStatus = newStatus;
        _networkStatusController.add(_currentStatus);
      }
    } catch (e) {
      if (kDebugMode) {
        print('Network check error: $e');
      }
      _currentStatus = NetworkStatus.unknown;
      _networkStatusController.add(_currentStatus);
    }
  }
  Future<bool> hasInternetConnection() async {
    try {
      return await InternetConnection().hasInternetAccess;
    } catch (e) {
      if (kDebugMode) {
        print('Internet connection check failed: $e');
      }
      return false;
    }
  }
  Future<bool> hasInternetConnectionWithCustom({Duration? timeout}) async {
    try {
      final internetConnection = InternetConnection();
      return await internetConnection.hasInternetAccess;
    } catch (e) {
      if (kDebugMode) {
        print('Custom internet connection check failed: $e');
      }
      return false;
    }
  }
  Future<bool> isConnected() async {
    return await hasInternetConnection();
  }
  Future<InternetStatus> getInternetStatus() async {
    try {
      final hasConnection = await InternetConnection().hasInternetAccess;
      return hasConnection
          ? InternetStatus.connected
          : InternetStatus.disconnected;
    } catch (e) {
      if (kDebugMode) {
        print('Get internet status failed: $e');
      }
      return InternetStatus.disconnected;
    }
  }
  void dispose() {
    _connectivitySubscription?.cancel();
    _networkStatusController.close();
  }
}
class NetworkException implements Exception {
  final String message;
  final NetworkStatus status;
  NetworkException(this.message, this.status);
  @override
  String toString() => 'NetworkException: $message';
}

