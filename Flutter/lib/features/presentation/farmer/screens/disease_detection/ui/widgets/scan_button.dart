import 'package:flutter/material.dart';
import 'package:projects/core/theme/app_colors.dart';

class ScanButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback onTap;

  const ScanButton({super.key, required this.enabled, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: const Text(
            "Scan",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
