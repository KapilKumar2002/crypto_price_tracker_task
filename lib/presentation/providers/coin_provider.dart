import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/services/binance_api_service.dart';
import '../../data/services/coin_repository.dart';
import '../../data/services/websocket_service.dart';


final coinRepositoryProvider = Provider<CoinRepository>((ref) {
  return CoinRepository(
    apiService: BinanceApiService(),
    webSocketService: WebSocketService(),
  );
});

final realTimePriceProvider = StreamProvider.family<double, String>((ref, symbol) {
  final repository = ref.watch(coinRepositoryProvider);
  return repository.getRealTimePrice(symbol);
});

final historicalDataProvider = FutureProvider.family<List<double>, Map<String, String>>((ref, params) async {
  final repository = ref.watch(coinRepositoryProvider);
  final data = await repository.getHistoricalData(params['symbol']!, params['interval']!);
  print(data);
  return data;
});