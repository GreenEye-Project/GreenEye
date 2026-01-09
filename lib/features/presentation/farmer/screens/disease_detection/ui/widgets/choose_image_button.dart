import 'package:flutter/material.dart';
import 'package:projects/core/theme/app_colors.dart';

class ChooseImageButton extends StatelessWidget {
  final VoidCallback onGallery;
  final VoidCallback onCamera;

  const ChooseImageButton({
    super.key,
    required this.onGallery,
    required this.onCamera,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: SizedBox(
        height: 40,
        child: ElevatedButton(
          onPressed: () async {
            final RenderBox button = context.findRenderObject() as RenderBox;
            final RenderBox overlay =
                Overlay.of(context).context.findRenderObject() as RenderBox;

            // Calculate position to show menu below the button
            final RelativeRect position = RelativeRect.fromRect(
              Rect.fromPoints(
                button.localToGlobal(Offset.zero, ancestor: overlay),
                button.localToGlobal(
                  button.size.bottomRight(Offset.zero),
                  ancestor: overlay,
                ),
              ).translate(0, button.size.height),
              Offset.zero & overlay.size,
            );

            final selected = await showMenu<String>(
              context: context,
              position: position,
              color: Colors.white,
              elevation: 1,
              constraints: BoxConstraints(
                minWidth: button.size.width,
                maxWidth: button.size.width,
              ),
              items: [
                PopupMenuItem(
                  value: 'gallery',
                  height: 40, // Same as button height
                  child: const Row(
                    children: [
                      Icon(Icons.photo_library, color: AppColors.darkGrey),
                      SizedBox(width: 8),
                      Text(
                        'Gallery',
                        style: TextStyle(color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                ),
                PopupMenuItem(
                  value: 'camera',
                  height: 40, // Same as button height
                  child: const Row(
                    children: [
                      Icon(
                        Icons.camera_alt_outlined,
                        color: AppColors.darkGrey,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Camera',
                        style: TextStyle(color: AppColors.darkGrey),
                      ),
                    ],
                  ),
                ),
              ],
            );

            if (selected == 'gallery') onGallery();
            if (selected == 'camera') onCamera();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: AppColors.secondaryColor),
            ),
          ),
          child: const Text(
            "Choose Image",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.darkGreenish,
            ),
          ),
        ),
      ),
    );
  }
}
