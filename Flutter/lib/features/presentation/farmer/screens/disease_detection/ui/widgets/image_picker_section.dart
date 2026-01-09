import 'dart:io';
import 'package:flutter/material.dart';
import 'package:projects/core/theme/app_colors.dart';

class ImagePickerSection extends StatelessWidget {
  final File? selectedImage;

  const ImagePickerSection({super.key, required this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 220,
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.darkGrey,
        borderRadius: BorderRadius.circular(12),
        image: selectedImage != null
            ? DecorationImage(
                image: FileImage(selectedImage!),
                fit: BoxFit.cover,
              )
            : null,
      ),
      child: selectedImage == null
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.image_outlined, size: 50, color: Colors.white),
                  SizedBox(height: 8),
                  Text(
                    "Please choose an image for scanning",
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            )
          : null,
    );
  }
}
