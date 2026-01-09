import 'package:flutter/material.dart';
import '/core/models/simulation_data.dart';

class FertilizerNeedsSection extends StatelessWidget {
  final SimulationData data;
  const FertilizerNeedsSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final n = 70, p = 45, k = 36;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Fertilizer Needs (N–P–K)",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _barItem("Nitrogen", n, "N = 78 kg/ha"),
          _barItem("Phosphorus", p, "P = 42 kg/ha"),
          _barItem("Potassium", k, "K = 27 kg/ha"),
        ],
      ),
    );
  }

  Widget _barItem(String title, int percent, String note) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        children: [
          Row(
            children: [
              Text(title),
              const Spacer(),
              Text(
                "$percent%",
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Container(
            height: 12,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(8),
            ),
            child: FractionallySizedBox(
              widthFactor: percent / 100.0,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green.shade600,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text(
                note,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}