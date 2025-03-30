import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:learn_websocket_crypto/config/constants/api_endpoints.dart';

import '../providers/coin_provider.dart';

class CoinTile extends ConsumerWidget {
  final String symbol;
  final VoidCallback onTap;

  const CoinTile({super.key, required this.symbol, required this.onTap});

  String getCoinImage(String symbol) {
    final coinImages = {
      "BTCUSDT": "1/large/bitcoin.png",
      "ETHUSDT": "279/large/ethereum.png",
      "BNBUSDT": "825/large/binance-coin-logo.png",
    };
    return ApiEndpoints.baseImageUrl +
        (coinImages[symbol] ?? "placeholder.png");
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final price = ref.watch(realTimePriceProvider(symbol));

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.transparent,
          backgroundImage: NetworkImage(getCoinImage(symbol)),
          radius: 24,
        ),
        title: Text(
          symbol.replaceAll("USDT", ""),
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: price.when(
          data: (value) => Text(
            "\$${value.toStringAsFixed(2)}",
            style: const TextStyle(color: Colors.green, fontSize: 16),
          ),
          loading: () =>
              const Text("Loading...", style: TextStyle(color: Colors.grey)),
          error: (_, __) =>
              const Text("Error", style: TextStyle(color: Colors.red)),
        ),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }
}
