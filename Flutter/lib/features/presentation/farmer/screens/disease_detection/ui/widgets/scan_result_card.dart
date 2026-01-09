import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '/core/theme/app_colors.dart';
import 'treatment_product_item.dart';

class ScanResultCard extends StatelessWidget {
  final Map<String, dynamic> result;

  const ScanResultCard({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ───────────── HEADER ─────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Crop",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: AppColors.critical,
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
              Text(result["crop"] ?? "Unknown"),
              const SizedBox(height: 18),

              const Text(
                "Disease",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text(result["disease"] ?? "Unknown"),
              const SizedBox(height: 16),

              // ───────────── CAUSE ─────────────
              const Text(
                "Cause",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(result["cause"] ?? "Unknown cause"),
              const SizedBox(height: 16),

              // ───────────── TREATMENT ─────────────
              const Text(
                "Treatment",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(result["treatment"] ?? "Consult agricultural expert"),
              const SizedBox(height: 16),

              const Text(
                "Weather Impact:",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text("  • Avg Temp: ${result["weather"]?["temp"] ?? "N/A"}"),
              Text("  • Humidity: ${result["weather"]?["humidity"] ?? "N/A"}"),
              Text("  → ${result["weather"]?["risk"] ?? "N/A"}"),
              const SizedBox(height: 16),

              // ───────────── ACTIONS ─────────────
              const Text(
                "Recommended Actions",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),

              ...List.generate(
                (result["actions"] as List?)?.length ?? 0,
                (i) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text("${i + 1}. ${result["actions"][i]}"),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  const Spacer(),

                  Row(
                    children: const [
                      Icon(
                        Icons.share_outlined,
                        color: AppColors.darkGreenish,
                        size: 20,
                      ),
                      SizedBox(width: 4),
                      Text("Community"),
                    ],
                  ),

                  const SizedBox(width: 16),

                  Row(
                    children: [
                      SvgPicture.asset(
                        'assets/icons/refresh.svg',
                        width: 18,
                        height: 18,
                        colorFilter: const ColorFilter.mode(
                          AppColors.darkGreenish,
                          BlendMode.srcIn,
                        ),
                      ),
                      const SizedBox(width: 4),
                      const Text("Rescan"),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 30),

        const Center(
          child: Text(
            "Need treatment? You can buy it \nnow from the Marketplace",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12),
          ),
        ),
        const SizedBox(height: 20),

        const Text(
          "Treatment products",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...(result["products"] as List?)
                ?.map<Widget>((p) => TreatmentProductItem(product: p))
                .toList() ??
            [],

        const SizedBox(height: 20),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () {},
                child: const Text("Add to cart"),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryColor,
                ),
                child: const Text("Buy Now"),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
