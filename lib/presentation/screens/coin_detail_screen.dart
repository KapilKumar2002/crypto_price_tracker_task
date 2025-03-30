import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/notification_service.dart';
import '../providers/coin_provider.dart';
import '../widgets/crypto_chart.dart';
import '../widgets/interval_selector.dart';

class CoinDetailScreen extends ConsumerStatefulWidget {
  final String symbol;

  const CoinDetailScreen({super.key, required this.symbol});

  @override
  ConsumerState<CoinDetailScreen> createState() => _CoinDetailScreenState();
}

class _CoinDetailScreenState extends ConsumerState<CoinDetailScreen> {
  String interval = "1h";
  double? lastPrice;

  final List<String> intervals = ['1m', '5m', '15m', '1h', '6h', '1d'];

  String getCoinImage(String symbol) {
    final baseUrl = "https://assets.coingecko.com/coins/images/";
    final coinImages = {
      "BTCUSDT": "1/large/bitcoin.png",
      "ETHUSDT": "279/large/ethereum.png",
      "BNBUSDT": "825/large/binance-coin-logo.png",
    };
    return baseUrl + (coinImages[symbol] ?? "placeholder.png");
  }

  @override
  Widget build(BuildContext context) {
    final priceAsync = ref.watch(realTimePriceProvider(widget.symbol));

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back_ios)),
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(getCoinImage(widget.symbol)),
                radius: 18,
              ),
              const SizedBox(width: 8),
              Text(
                widget.symbol.replaceAll("USDT", ""),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          actions: [
            IntervalSelector(
              selected: interval,
              onChanged: (value) {
                setState(() => interval = value);
              },
            ),
          ],
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(255, 253, 225, 112),
                Color(0xffFBC700),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: priceAsync.when(
                    data: (price) {
                      if (lastPrice != null && price != lastPrice) {
                        NotificationService.showNotification(
                          "${widget.symbol} Updated",
                          "New Price: \$${price.toStringAsFixed(2)}",
                        );
                      }
                      lastPrice = price;
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 500),
                        transitionBuilder: (child, animation) => FadeTransition(
                          opacity: animation,
                          child: child,
                        ),
                        child: Text(
                          '\$${price.toStringAsFixed(2)}',
                          key: ValueKey(price),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      );
                    },
                    loading: () => const CircularProgressIndicator(),
                    error: (e, _) => Text('Error: $e'),
                  ),
                ),
                const SizedBox(height: 20),
                CryptoChart(
                  interval: interval,
                  symbol: widget.symbol,
                )
              ],
            ),
          ),
        ));
  }
}
