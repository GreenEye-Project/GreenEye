import 'package:flutter/material.dart';
import '/core/models/simulation_data.dart';

class CropStatusSection extends StatelessWidget {
  final SimulationData data;
  const CropStatusSection({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
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
            "Today's Crop Status",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          _row("LAI", "${(data.biomass / 1000 * 2).toStringAsFixed(2)}"),
          _row("Biomass", "${data.biomass.toStringAsFixed(0)} kg/ha"),
          _row("Soil Moisture", "${data.soilMoisture.toStringAsFixed(0)}%"),
          _row("Water stress", _stressLabel(data.waterStress)),
          _row("Heat stress", _stressLabel(data.heatStress)),
        ],
      ),
    );
  }

  String _stressLabel(double v) {
    if (v < 0.3) return "Low";
    if (v < 0.6) return "Medium";
    return "High";
  }

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            k,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          Text(
            v,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}