import 'package:flutter/material.dart';
import '../widgets/coin_tile.dart';
import 'coin_detail_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final coins = ["BTCUSDT", "ETHUSDT", "BNBUSDT"];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: const Text(
            "Crypto Tracker",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
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
          child: ListView.builder(
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
        ));
  }
}
