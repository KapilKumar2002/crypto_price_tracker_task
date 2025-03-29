import '../models/coin_model.dart';
import 'binance_api_service.dart';
import 'websocket_service.dart';

class CoinRepository {
  final BinanceApiService apiService;
  final WebSocketService webSocketService;

  CoinRepository({
    required this.apiService,
    required this.webSocketService,
  });

  Stream<double> getRealTimePrice(String symbol) {
    return webSocketService.connect(symbol);
  }

  Future<List<double>> getHistoricalData(String symbol, String interval) {
    return apiService.getHistoricalData(symbol, interval);
  }
}