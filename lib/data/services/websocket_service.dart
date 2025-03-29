import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  Stream<double> connect(String symbol) {
    _channel = WebSocketChannel.connect(
        Uri.parse('wss://stream.binance.com:9443/ws/${symbol.toLowerCase()}@trade'));

    return _channel!.stream.map((event) {
      final data = json.decode(event);
      return double.parse(data['p']);
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}