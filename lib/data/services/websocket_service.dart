import 'dart:convert';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../../config/constants/api_endpoints.dart';

class WebSocketService {
  WebSocketChannel? _channel;

  Stream<double> connect(String symbol) {
    _channel = WebSocketChannel.connect(
        Uri.parse('${ApiEndpoints.baseEndPoint}${symbol.toLowerCase()}@trade'));

    return _channel!.stream.map((event) {
      final data = json.decode(event);
      return double.parse(data['p']);
    });
  }

  void disconnect() {
    _channel?.sink.close();
  }
}
