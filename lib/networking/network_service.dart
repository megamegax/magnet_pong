import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:magnet_pong/models/player.dart';

class NetworkService {
  late WebSocketChannel _channel;
  Function(Map<String, dynamic>)? onGameStateReceived;
  Function()? onConnected;
  Function()? onDisconnected;

  void connect(String serverUrl) {
    _channel = WebSocketChannel.connect(Uri.parse(serverUrl));
    _channel.stream.listen((message) {
      final jsonMessage = jsonDecode(message);
      if (jsonMessage['type'] == 'gameState') {
        onGameStateReceived?.call(jsonMessage['data']);
      } else if (jsonMessage['type'] == 'connected') {
        onConnected?.call();
      }
    }, onDone: () {
      onDisconnected?.call();
    });
  }

  void sendInput(Map<String, dynamic> input) {
    _channel.sink.add(jsonEncode({'type': 'input', 'data': input}));
  }

  void disconnect() {
    _channel.sink.close();
  }
}