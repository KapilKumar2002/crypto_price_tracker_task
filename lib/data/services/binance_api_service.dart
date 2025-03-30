import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../config/constants/api_endpoints.dart';

class BinanceApiService {
  Future<List<double>> getHistoricalData(String symbol, String interval) async {
    final uri = Uri.parse(
        '${ApiEndpoints.baseHistoricalEndPoint}=$symbol&interval=$interval&limit=100');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data
          .map((candle) => double.parse(candle[4]))
          .toList(); // close prices
    } else {
      throw Exception('Failed to fetch historical data');
    }
  }
}
