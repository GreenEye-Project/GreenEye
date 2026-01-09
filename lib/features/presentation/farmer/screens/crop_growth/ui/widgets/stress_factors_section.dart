import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/core/models/simulation_data.dart';

class StressFactorsSection extends StatelessWidget {
  final SimulationData data;
  final List<SimulationData>? history;
  const StressFactorsSection({super.key, required this.data, this.history});

  List<SimulationData> _makeHistory() {
    if (history != null && history!.isNotEmpty) return history!;
    final now = data.timelineDay;
    return List.generate(10, (i) {
      final t = (now - (9 - i)) % 30;
      final baseWater = (i % 5) / 5.0;
      final baseHeat = ((9 - i) % 6) / 6.0;
      // ignore: unused_local_variable
      final baseSoil = 30 + (i * 3);
      return SimulationData(
        growthStage: data.growthStage,
        expectedYield: data.expectedYield,
        cropHealth: data.cropHealth,
        cropName: data.cropName,
        location: data.location,
        timelineDay: t,
        biomass: data.biomass,
        soilMoisture: data.soilMoisture,
        waterStress: baseWater,
        heatStress: baseHeat,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hist = _makeHistory();
    final soilSpots = <FlSpot>[];
    final waterSpots = <FlSpot>[];
    final heatSpots = <FlSpot>[];

    for (var i = 0; i < hist.length; i++) {
      final x = i.toDouble();
      final soil = (30 + (i * 3)).toDouble();
      final water = (hist[i].waterStress * 100);
      final heat = (hist[i].heatStress * 100);
      soilSpots.add(FlSpot(x, soil));
      waterSpots.add(FlSpot(x, water));
      heatSpots.add(FlSpot(x, heat));
    }

    final maxY = [
      soilSpots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b),
      waterSpots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b),
      heatSpots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b),
    ].reduce((a, b) => a > b ? a : b);

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
            "Stress Factors",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (soilSpots.length - 1).toDouble(),
                minY: 0,
                maxY: maxY * 1.05,
                gridData: FlGridData(show: true),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: soilSpots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 2.5,
                    color: Colors.orange.shade700,
                  ),
                  LineChartBarData(
                    spots: waterSpots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 2.0,
                    color: Colors.blue.shade700,
                  ),
                  LineChartBarData(
                    spots: heatSpots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 2.0,
                    color: Colors.red.shade400,
                  ),
                ],
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(enabled: true),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _legendDot(Colors.orange.shade700, "Soil Stress"),
              const SizedBox(width: 12),
              _legendDot(Colors.blue.shade700, "Water Stress"),
              const SizedBox(width: 12),
              _legendDot(Colors.red.shade400, "Heat Stress"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color c, String t) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: c,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(width: 6),
        Text(t, style: const TextStyle(fontSize: 13)),
      ],
    );
  }
}
