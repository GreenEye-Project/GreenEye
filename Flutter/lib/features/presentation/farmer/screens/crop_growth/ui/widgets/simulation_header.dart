import 'package:flutter/material.dart';
import '/core/models/simulation_data.dart';

class SimulationHeader extends StatelessWidget {
  final SimulationData data;
  const SimulationHeader({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 420,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xff002c25), Color(0xff003c2e)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Container(
              height: 300,
              width: 260,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.20),
                    Colors.white.withOpacity(0.05),
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Crop growth Simulation",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                const SizedBox(height: 8),
                Text(
                  "Current Growth Stage\n${data.growthStage}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 28),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "Expected Yield",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          "${data.expectedYield}",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          "Crop Health",
                          style: TextStyle(color: Colors.white70, fontSize: 13),
                        ),
                        Text(
                          "${(data.cropHealth * 100).round()}%",
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  "Crop: ${data.cropName}\n${data.location}",
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xff007a53),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Text(
                    data.growthStage,
                    style: const TextStyle(color: Colors.white, fontSize: 15),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}