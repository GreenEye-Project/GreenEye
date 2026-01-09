import 'package:flutter/material.dart';
import '/core/models/simulation_data.dart';

class SoilQualitySection extends StatelessWidget {
  final SimulationData data;
  const SoilQualitySection({super.key, required this.data});

  double _textureScore() =>
      (6.0 + ((data.soilMoisture - 20) / 10)).clamp(0.0, 10.0);
  double _nutrientScore() =>
      (5.0 + ((data.biomass / 2000) - 0.5) * 3).clamp(0.0, 10.0);
  double _organicMatter() => 2.1;

  @override
  Widget build(BuildContext context) {
    final overall = ((_textureScore() + _nutrientScore()) / 2).clamp(0.0, 10.0);

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
            "Overall Soil Quality",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _circularScore(overall, label: "Overall"),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _scoreRow(
                      "Texture Score",
                      _textureScore(),
                      "Loam-Silt mix",
                    ),
                    _scoreRow(
                      "Nutrient Score",
                      _nutrientScore(),
                      "Moderate nutrient levels",
                    ),
                    _infoRow("Organic Matter", "${_organicMatter()}%"),
                    _infoRow("Soil Stress", "Medium"),
                    _infoRow("Soil Moisture", "${data.soilMoisture}%"),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _circularScore(double val, {String label = ""}) {
    final percent = (val / 10.0).clamp(0.0, 1.0);
    return SizedBox(
      width: 96,
      height: 96,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: percent,
            strokeWidth: 8,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(Colors.green.shade600),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                val.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _scoreRow(String title, double score, String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(child: Text(title)),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                score.toStringAsFixed(1),
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _infoRow(String k, String v) {
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k),
          Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}