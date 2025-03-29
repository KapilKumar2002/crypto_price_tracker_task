import 'package:flutter/material.dart';
import '../widgets/coin_tile.dart';
import 'coin_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coins = ["BTCUSDT", "ETHUSDT", "BNBUSDT"];

    return Scaffold(
      appBar: AppBar(title: const Text('Crypto Tracker')),
      body: ListView.builder(
        itemCount: coins.length,
        itemBuilder: (context, index) {
          return CoinTile(
            symbol: coins[index],
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => CoinDetailScreen(symbol: coins[index]),
              ),
            ),
          );
        },
      ),
    );
  }
}