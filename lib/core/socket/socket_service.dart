import 'package:socket_io_client/socket_io_client.dart' as io;

import '../constants/api_constants.dart';

/// Manages the authenticated Socket.io connection and exposes typed event
/// streams. Connection is (re)established with the current access token.
class SocketService {
  io.Socket? _socket;

  final _handlers = <String, void Function(dynamic)>{};

  bool get isConnected => _socket?.connected ?? false;

  void connect(String accessToken) {
    disconnect();
    final socket = io.io(
      ApiConstants.baseUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .build(),
    );
    // Re-attach any registered handlers.
    _handlers.forEach(socket.on);
    socket.connect();
    _socket = socket;
  }

  /// Register a listener for [event]; survives reconnects.
  void on(String event, void Function(dynamic data) handler) {
    _handlers[event] = handler;
    _socket?.on(event, handler);
  }

  void off(String event) {
    _handlers.remove(event);
    _socket?.off(event);
  }

  void disconnect() {
    _socket?.dispose();
    _socket = null;
  }
}
