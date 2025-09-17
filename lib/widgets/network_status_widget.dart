import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../core/di/injection.dart';
class NetworkStatusWidget extends StatefulWidget {
  final Widget child;
  final bool showOfflineMessage;
  const NetworkStatusWidget({
    super.key,
    required this.child,
    this.showOfflineMessage = true,
  });
  @override
  State<NetworkStatusWidget> createState() => _NetworkStatusWidgetState();
}
class _NetworkStatusWidgetState extends State<NetworkStatusWidget> {
  late final NetworkService _networkService;
  NetworkStatus _currentStatus = NetworkStatus.unknown;
  @override
  void initState() {
    super.initState();
    _networkService = getIt<NetworkService>();
    _currentStatus = _networkService.currentStatus;
    _networkService.networkStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _currentStatus = status;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_currentStatus == NetworkStatus.disconnected &&
            widget.showOfflineMessage)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            color: Colors.red.shade600,
            child: Row(
              children: [
                const Icon(Icons.wifi_off, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'No internet connection',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    final isConnected = await _networkService.isConnected();
                    if (isConnected && mounted) {
                      setState(() {
                        _currentStatus = NetworkStatus.connected;
                      });
                    }
                  },
                  child: const Text(
                    'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        if (_currentStatus == NetworkStatus.connected &&
            widget.showOfflineMessage)
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
            color: Colors.black,
            child: const Row(
              children: [
                Icon(Icons.wifi, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Connected',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }
}
class NetworkStatusIndicator extends StatefulWidget {
  final double size;
  final Color? connectedColor;
  final Color? disconnectedColor;
  const NetworkStatusIndicator({
    super.key,
    this.size = 24,
    this.connectedColor,
    this.disconnectedColor,
  });
  @override
  State<NetworkStatusIndicator> createState() => _NetworkStatusIndicatorState();
}
class _NetworkStatusIndicatorState extends State<NetworkStatusIndicator> {
  late final NetworkService _networkService;
  NetworkStatus _currentStatus = NetworkStatus.unknown;
  @override
  void initState() {
    super.initState();
    _networkService = getIt<NetworkService>();
    _currentStatus = _networkService.currentStatus;
    _networkService.networkStatusStream.listen((status) {
      if (mounted) {
        setState(() {
          _currentStatus = status;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    IconData icon;
    Color color;
    switch (_currentStatus) {
      case NetworkStatus.connected:
        icon = Icons.wifi;
        color = widget.connectedColor ?? Colors.black;
        break;
      case NetworkStatus.disconnected:
        icon = Icons.wifi_off;
        color = widget.disconnectedColor ?? Colors.red;
        break;
      case NetworkStatus.unknown:
        icon = Icons.wifi_find;
        color = Colors.orange;
        break;
    }
    return Icon(icon, size: widget.size, color: color);
  }
}

