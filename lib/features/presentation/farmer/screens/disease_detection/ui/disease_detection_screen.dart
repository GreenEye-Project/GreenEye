import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/core/theme/app_colors.dart';
import '/core/network/session_manager.dart';
import 'widgets/image_picker_section.dart';
import 'widgets/tips_section.dart';
import 'widgets/scan_button.dart';
import 'widgets/choose_image_button.dart';
import 'widgets/scan_result_card.dart';
import 'widgets/plant_growth_animation.dart';
import 'disease_detection_controller.dart';

class DiseaseDetectionScreen extends StatefulWidget {
  const DiseaseDetectionScreen({super.key});

  @override
  State<DiseaseDetectionScreen> createState() => _DiseaseDetectionScreenState();
}

class _DiseaseDetectionScreenState extends State<DiseaseDetectionScreen> {
  File? selectedImage;
  Map<String, dynamic>? scanResult;
  bool isScanning = false;
  bool isCheckingAuth = true;
  bool isAuthenticated = false;
  String? errorMessage;

  final DiseaseDetectionController controller = DiseaseDetectionController();
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    final loggedIn = await SessionManager.isLoggedIn();
    final token = await SessionManager.accessToken;

    setState(() {
      isAuthenticated = loggedIn && token != null && token.isNotEmpty;
      isCheckingAuth = false;
    });

    if (!isAuthenticated) {
      print('⚠️ User not authenticated');
    } else {
      print('✅ User authenticated - Token exists');
    }
  }

  bool _isValidImageFormat(String path) {
    final extension = path.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'heic', 'webp'].contains(extension);
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        if (!_isValidImageFormat(image.path)) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Please select a valid image file (JPG, PNG)'),
                backgroundColor: Colors.orange,
              ),
            );
          }
          return;
        }

        setState(() {
          selectedImage = File(image.path);
          scanResult = null;
          errorMessage = null;
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _pickFromCamera() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          selectedImage = File(image.path);
          scanResult = null;
          errorMessage = null;
        });
      }
    } catch (e) {
      print('Error taking photo: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to take photo: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading while checking auth
    if (isCheckingAuth) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        body: Center(
          child: CircularProgressIndicator(color: AppColors.primaryColor),
        ),
      );
    }

    // Show login required message if not authenticated
    if (!isAuthenticated) {
      return Scaffold(
        backgroundColor: AppColors.lightGrey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 80, color: AppColors.darkGrey),
                const SizedBox(height: 24),
                Text(
                  'Authentication Required',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkGreenish,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Please log in to use the disease detection feature.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: AppColors.darkGrey),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 48,
                      vertical: 16,
                    ),
                  ),
                  child: const Text(
                    'Go Back',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Main screen (user is authenticated)
    return Scaffold(
      backgroundColor: AppColors.lightGrey,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                "Disease Detection",
                style: TextStyle(
                  color: AppColors.darkGreenish,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            const SizedBox(height: 20),

            /// IMAGE PREVIEW (DISPLAY ONLY)
            ImagePickerSection(selectedImage: selectedImage),

            const SizedBox(height: 16),

            Row(
              children: [
                /// DROPDOWN IMAGE PICKER
                ChooseImageButton(
                  onGallery: _pickFromGallery,
                  onCamera: _pickFromCamera,
                ),

                const SizedBox(width: 12),

                /// SCAN BUTTON
                ScanButton(
                  enabled: selectedImage != null && !isScanning,
                  onTap: () async {
                    if (selectedImage == null || isScanning) return;

                    setState(() {
                      isScanning = true;
                      errorMessage = null;
                      scanResult = null;
                    });

                    try {
                      final result = await controller.scanImage(selectedImage!);
                      setState(() {
                        scanResult = result;
                        isScanning = false;
                      });
                    } catch (e) {
                      setState(() {
                        isScanning = false;
                        errorMessage = e.toString().replaceAll(
                          'Exception: ',
                          '',
                        );
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            /// LOADING INDICATOR - PLANT GROWTH ANIMATION (FASTER & SMALLER)
            if (isScanning) const Center(child: PlantGrowthAnimation()),

            /// ERROR MESSAGE
            if (errorMessage != null && !isScanning)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.red.shade200),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline, color: Colors.red.shade700),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Error',
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            errorMessage!,
                            style: TextStyle(
                              color: Colors.red.shade700,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            /// TIPS OR RESULTS
            if (scanResult == null && !isScanning && errorMessage == null)
              const TipsSection(),
            if (scanResult != null && !isScanning)
              ScanResultCard(result: scanResult!),
          ],
        ),
      ),
    );
  }
}
