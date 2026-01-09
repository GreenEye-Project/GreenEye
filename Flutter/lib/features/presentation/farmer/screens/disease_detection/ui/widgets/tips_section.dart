import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

class TipsSection extends StatefulWidget {
  const TipsSection({super.key});

  @override
  State<TipsSection> createState() => _TipsSectionState();
}

class _TipsSectionState extends State<TipsSection> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Diagnosis",
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.darkGreenish,
          ),
        ),
        const SizedBox(height: 10),

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
              const Text(
                "Nothing scanned yet",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Snap a close-up photo of the leaf or upload one from your gallery. We'll tell you what we detect and suggest next steps.",
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 12,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 12),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                  color: AppColors.white,
                ),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () => setState(() => expanded = !expanded),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 10,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Tips for better scan?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColors.darkGrey,
                              ),
                            ),
                            Icon(
                              expanded
                                  ? Icons.keyboard_arrow_up
                                  : Icons.keyboard_arrow_down,
                            ),
                          ],
                        ),
                      ),
                    ),

                    if (expanded) ...[
                      Container(
                        padding: const EdgeInsets.only(
                          left: 10,
                          right: 10,
                          bottom: 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            _buildTipItem(
                              "• Keep the damaged leaf in the center.",
                            ),
                            _buildTipItem(
                              "• Avoid glare and heavy shadow — take in soft daylight.",
                            ),
                            _buildTipItem(
                              "• Fill the frame with the leaf (no distant shots).",
                            ),
                            _buildTipItem(
                              "• Take 2–3 photos from different angles if possible.",
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
                color: AppColors.darkGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
