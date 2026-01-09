import 'package:flutter/material.dart';
import '/core/theme/app_colors.dart';

class UploadBox extends StatelessWidget {
  final String label;
  final String? subtitle;
  final VoidCallback onTap;
  final double? width;
  final double? height;
  final bool isLoading;
  final String? errorMessage;

  const UploadBox({
    super.key,
    required this.label,
    this.subtitle,
    required this.onTap,
    this.width,
    this.height,
    this.isLoading = false,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        width: width ?? 120,
        height: height ?? 120,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
            color: errorMessage != null
                ? Colors.red
                : Colors.grey.withOpacity(0.3),
            width: errorMessage != null ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.primaryColor),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.cloud_upload_outlined,
                    size: 40,
                    color: errorMessage != null
                        ? Colors.red
                        : Colors.grey.shade400,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      color: errorMessage != null
                          ? Colors.red
                          : AppColors.primaryColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 4),
                    Text(
                      subtitle!,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                  if (errorMessage != null) ...[
                    const SizedBox(height: 4),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(fontSize: 11, color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}
