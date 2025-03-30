import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/coin_provider.dart';

class CryptoChart extends ConsumerStatefulWidget {
  final String symbol;
  final String interval;

  const CryptoChart({Key? key, required this.symbol, required this.interval})
      : super(key: key);

  @override
  ConsumerState<CryptoChart> createState() => _CryptoChartState();
}

class _CryptoChartState extends ConsumerState<CryptoChart> {
  List<FlSpot> priceData = [];
  int timeCounter = 0;

  @override
  void initState() {
    super.initState();
    fetchHistoricalData();
  }

  @override
  void didUpdateWidget(covariant CryptoChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.interval != widget.interval) {
      fetchHistoricalData();
    }
  }

  void fetchHistoricalData() async {
    final params = {'symbol': widget.symbol, 'interval': widget.interval};
    final historicalPrices =
        await ref.read(historicalDataProvider(params).future);

    setState(() {
      priceData = historicalPrices
          .asMap()
          .entries
          .map((e) => FlSpot(e.key.toDouble(), e.value))
          .toList();
      timeCounter = priceData.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final realTimePrice = ref.watch(realTimePriceProvider(widget.symbol));

    realTimePrice.whenData((latestPrice) {
      if (priceData.isNotEmpty) {
        setState(() {
          timeCounter++;
          priceData.add(FlSpot(timeCounter.toDouble(), latestPrice));

          if (priceData.length > 50) {
            priceData.removeAt(0);
          }
        });
      }
    });

    return Container(
      height: 300,
      padding: const EdgeInsets.all(16),
      child: priceData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : LineChart(
              LineChartData(
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          "\$${value.toStringAsFixed(2)}",
                          style: const TextStyle(fontSize: 8),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: const TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                lineBarsData: [
                  LineChartBarData(
                    spots: priceData,
                    isCurved: true,
                    color: Colors.blue,
                    barWidth: 3,
                    belowBarData: BarAreaData(show: false),
                  ),
                ],
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.grey, width: 1),
                ),
                minX: priceData.first.x,
                maxX: priceData.last.x,
              ),
            ),
    );
  }
}
