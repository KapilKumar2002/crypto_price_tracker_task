import 'package:flutter/material.dart';

class CoinTile extends StatelessWidget {
  final String symbol;
  final VoidCallback onTap;

  const CoinTile({super.key, required this.symbol, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(symbol, style: const TextStyle(fontWeight: FontWeight.bold)),
      trailing: const Icon(Icons.arrow_forward_ios),
      onTap: onTap,
    );
  }
}