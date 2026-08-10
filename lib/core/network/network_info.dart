/// Interface for checking network connectivity
abstract class NetworkInfo {
  /// Returns true if the device is connected to the internet
  Future<bool> get isConnected;
  
  /// Returns the current network status
  Future<NetworkStatus> get networkStatus;
}

/// Network status enum
enum NetworkStatus {
  connected,
  disconnected,
}