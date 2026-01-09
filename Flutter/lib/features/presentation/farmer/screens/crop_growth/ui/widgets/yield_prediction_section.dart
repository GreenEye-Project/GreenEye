import 'package:flutter/material.dart';
import '/core/models/simulation_data.dart';

class YieldPredictionSection extends StatelessWidget {
  final SimulationData data;
  const YieldPredictionSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final max = 8.2;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, 3),
            blurRadius: 6,
            color: Colors.black.withOpacity(0.06),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Season Predictions",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            "Yield Predictions",
            style: TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 10),
          _bar("Predicted Yield", data.expectedYield, max),
          const SizedBox(height: 8),
          _bar("Potential Yield", 6.85, max),
        ],
      ),
    );
  }

  Widget _bar(String label, double value, double max) {
    final percent = (value / max).clamp(0.0, 1.0);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label),
        const SizedBox(height: 6),
        Container(
          height: 12,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: percent,
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xff2F9C67),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "${value.toStringAsFixed(2)} ton/ha",
          style: TextStyle(color: Colors.grey.shade700),
        ),
      ],
    );
  }
}