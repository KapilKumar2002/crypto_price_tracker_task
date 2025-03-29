import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class LineChartWidget extends StatelessWidget {
  final List<double> prices;

  const LineChartWidget({super.key, required this.prices});

  @override
  Widget build(BuildContext context) {
    if (prices.isEmpty || prices.length < 2) {
      return const Center(child: Text('No data available'));
    }

    final List<FlSpot> spots = prices
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
        .toList();

    double minY = prices.reduce((a, b) => a < b ? a : b);
    double maxY = prices.reduce((a, b) => a > b ? a : b);
    final double yRange = maxY - minY;

    // Add padding to Y-axis if all values are equal
    if (yRange == 0) {
      minY -= 1;
      maxY += 1;
    } else {
      final double padding = yRange * 0.1;
      minY -= padding;
      maxY += padding;
    }

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          minY: minY,
          maxY: maxY,
          titlesData: FlTitlesData(
            show: true,
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                reservedSize: 40,
                interval: _calculateYInterval(maxY - minY),
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) => Text(
                  value.toInt().toString(),
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
                reservedSize: 22,
                interval: _calculateXInterval(prices.length),
              ),
            ),
          ),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            getDrawingHorizontalLine: (value) => const FlLine(
              color: Colors.grey,
              strokeWidth: 0.2,
            ),
          ),
          borderData: FlBorderData(
            show: true,
            border: const Border(
              left: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              curveSmoothness: 0.3,
              gradient: LinearGradient(
                colors: [
                  Colors.amber.shade400,
                  Colors.orange.shade700,
                ],
              ),
              barWidth: 3,
              dotData: const FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.withOpacity(0.2),
                    Colors.orange.withOpacity(0.05),
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  double _calculateYInterval(double range) {
    if (range <= 50) return 10;
    if (range <= 200) return 50;
    return 100;
  }

  double _calculateXInterval(int dataLength) {
    if (dataLength <= 30) return 5;
    if (dataLength <= 100) return 10;
    return 20;
  }
}