import 'package:flutter/material.dart';

class GeneralInfoSection extends StatelessWidget {
  const GeneralInfoSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "General Info",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(0xffeef9f2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text("Estimated Duration", style: TextStyle(fontSize: 14)),
                SizedBox(height: 6),
                Text(
                  "24 days",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 10),
                Text("Planting Date - 20 Nov 2025"),
                SizedBox(height: 4),
                Text("Harvest Date - 14 Dec 2025"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}