import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/utils/notification_service.dart';
import '../providers/coin_provider.dart';
import '../widgets/line_chart.dart';
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

  @override
  Widget build(BuildContext context) {
    final priceAsync = ref.watch(realTimePriceProvider(widget.symbol));
    final historicalAsync = ref.watch(historicalDataProvider({
      'symbol': widget.symbol,
      'interval': interval,
    }));


    return Scaffold(
      appBar: AppBar(title: Text(widget.symbol)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IntervalSelector(
              selected: interval,
              onChanged: (val) => setState(() => interval = val),
            ),
            const SizedBox(height: 10),
            priceAsync.when(
              data: (price) {
                if (lastPrice != null && price != lastPrice) {
                  NotificationService.showNotification(
                    "${widget.symbol} Updated",
                    "New Price: \$${price.toStringAsFixed(2)}",
                  );
                }
                lastPrice = price;
                return Text(
                  '\$${price.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                );
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text('Error: $e'),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: historicalAsync.when(
                data: (prices) {
                  debugPrint('Data received: ${prices.length} items');
                  debugPrint('First 5 values: ${prices.sublist(0, 5)}');
                  return LineChartWidget(prices: prices);
                },
                loading: () {
                  debugPrint('Still loading...');
                  return const Center(child: CircularProgressIndicator());
                },
                error: (e, _) {
                  debugPrint('Error occurred: $e');
                  return Text('Chart error: $e');
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}