import 'package:flutter/material.dart';

class IntervalSelector extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const IntervalSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    const intervals = ['1m', '5m', '15m', '1h', '6h', '1d', '1M'];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xffFBC700),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: PopupMenuButton<String>(
        onSelected: (value) => onChanged(value),
        icon: const Icon(Icons.filter_list, color: Colors.black),
        color: const Color(0xffFBC700), // Background of menu items
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        itemBuilder: (context) => intervals
            .map((interval) => PopupMenuItem(
                  value: interval,
                  child: Text(
                    interval,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }
}
