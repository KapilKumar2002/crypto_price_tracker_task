import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class IntervalSelector extends StatelessWidget {
  final String selected;
  final Function(String) onChanged;

  const IntervalSelector({super.key, required this.selected, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    const intervals = ['1m', '5m', '15m', '1h', '6h', '1d'];

    return SizedBox(
      height: 40,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: intervals.length,
        itemBuilder: (context, index) {
          final interval = intervals[index];
          final isSelected = interval == selected;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6.0),
            child: ChoiceChip(
              label: Text(interval),
              selected: isSelected,
              onSelected: (_) => onChanged(interval),
            ),
          );
        },
      ),
    );
  }
}