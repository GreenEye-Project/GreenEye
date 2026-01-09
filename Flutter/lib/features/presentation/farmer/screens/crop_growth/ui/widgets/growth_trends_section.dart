import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '/core/models/simulation_data.dart';

class GrowthTrendsSection extends StatelessWidget {
  final SimulationData data;
  final List<SimulationData>? history;
  const GrowthTrendsSection({super.key, required this.data, this.history});

  List<SimulationData> _makeHistory() {
    if (history != null && history!.isNotEmpty) return history!;
    final now = data.timelineDay;
    return List.generate(10, (i) {
      final t = (now - (9 - i)) % 30;
      final variation = ((i - 4.5) * 50);
      return SimulationData(
        growthStage: data.growthStage,
        expectedYield: data.expectedYield,
        cropHealth: data.cropHealth,
        cropName: data.cropName,
        location: data.location,
        timelineDay: t,
        biomass: (data.biomass + variation).clamp(200.0, 8000.0),
        soilMoisture: data.soilMoisture,
        waterStress: data.waterStress,
        heatStress: data.heatStress,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final hist = _makeHistory();
    final biomassSpots = <FlSpot>[];
    final laiSpots = <FlSpot>[];

    for (var i = 0; i < hist.length; i++) {
      final x = i.toDouble();
      final b = hist[i].biomass;
      final lai = (b / 1000.0) * 2.0;
      biomassSpots.add(FlSpot(x, b));
      laiSpots.add(FlSpot(x, lai));
    }

    final maxY = [
      biomassSpots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b),
      laiSpots.map((s) => s.y).fold<double>(0, (a, b) => a > b ? a : b),
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
            "Growth Trends",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: LineChart(
              LineChartData(
                minX: 0,
                maxX: (biomassSpots.length - 1).toDouble(),
                minY: 0,
                maxY: maxY * 1.15,
                gridData: FlGridData(show: true, horizontalInterval: maxY / 4),
                titlesData: FlTitlesData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: biomassSpots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 3,
                    color: Colors.green.shade700,
                  ),
                  LineChartBarData(
                    spots: laiSpots,
                    isCurved: true,
                    dotData: FlDotData(show: false),
                    barWidth: 2.5,
                    color: Colors.teal,
                  ),
                ],
                borderData: FlBorderData(show: false),
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchTooltipData: LineTouchTooltipData(
                    getTooltipColor: (touchedSpot) => Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _legendDot(Colors.green.shade700, "Biomass (kg/ha)"),
              const SizedBox(width: 12),
              _legendDot(Colors.teal, "LAI"),
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