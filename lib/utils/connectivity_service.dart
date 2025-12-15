import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamController<bool> _connectionStatusController = StreamController<bool>.broadcast();

  Stream<bool> get connectionStatus => _connectionStatusController.stream;

  bool _hasConnection = false;
  bool get hasConnection => _hasConnection;

  Future<void> initialize() async {
    // Initial check
    await _checkConnectivity();
    
    // Listen for connectivity changes
    _connectivity.onConnectivityChanged.listen((result) {
      _hasConnection = result != ConnectivityResult.none;
      _connectionStatusController.add(_hasConnection);
    });
  }

  Future<void> _checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _hasConnection = result != ConnectivityResult.none;
    _connectionStatusController.add(_hasConnection);
  }

  void dispose() {
    _connectionStatusController.close();
  }
}