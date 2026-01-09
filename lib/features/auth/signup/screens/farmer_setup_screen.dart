import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/shared/widgets/inputs/custom_text_field.dart';
import '/shared/widgets/inputs/upload_box.dart';
import '/shared/widgets/inputs/loading_overlay.dart';
import '/core/theme/app_colors.dart';
import '/core/utils/validators.dart';

class FarmerSetupScreen extends StatefulWidget {
  const FarmerSetupScreen({super.key});

  @override
  State<FarmerSetupScreen> createState() => _FarmerSetupScreenState();
}

class _FarmerSetupScreenState extends State<FarmerSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _location = TextEditingController();
  final _areaSize = TextEditingController();

  String? _selectedImage;
  String _areaUnit = "Feddan";
  bool _isUploadingImage = false;
  // ignore: unused_field
  String? _uploadedImageUrl;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _name.dispose();
    _location.dispose();
    _areaSize.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1024,
        maxHeight: 1024,
        imageQuality: 85,
      );

      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile.path;
        });

        // Upload image to backend
        await _uploadImage(File(pickedFile.path));
      }
    } catch (e) {
      _showError('Error picking image: $e');
    }
  }

  Future<void> _uploadImage(File image) async {
    setState(() {
      _isUploadingImage = true;
    });

    try {
      // TODO: Implement actual image upload to your backend
      // Example:
      // final formData = FormData.fromMap({
      //   'image': await MultipartFile.fromFile(image.path),
      // });
      // final response = await DioClient.post('/upload/profile-image', data: formData);
      // _uploadedImageUrl = response.data['url'];

      // Simulating upload
      await Future.delayed(const Duration(seconds: 2));
      _uploadedImageUrl = 'https://example.com/image.jpg'; // Mock URL

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image uploaded successfully'),
            backgroundColor: AppColors.primaryColor,
          ),
        );
      }
    } catch (e) {
      _showError('Failed to upload image: $e');
      setState(() {
        _selectedImage = null;
      });
    } finally {
      setState(() {
        _isUploadingImage = false;
      });
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  Future<bool> _onWillPop() async {
    if (_name.text.isNotEmpty ||
        _location.text.isNotEmpty ||
        _areaSize.text.isNotEmpty) {
      final shouldPop = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Discard Changes?'),
          content: const Text(
            'You have unsaved information. Are you sure you want to go back?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context, true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Discard'),
            ),
          ],
        ),
      );
      return shouldPop ?? false;
    }
    return true;
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    LoadingOverlay.show(context, message: 'Setting up your profile...');

    try {
      // TODO: Submit to backend
      // await FarmerRepository.createProfile(
      //   name: _name.text.trim(),
      //   location: _location.text.trim(),
      //   areaSize: double.parse(_areaSize.text),
      //   areaUnit: _areaUnit,
      //   profileImage: _uploadedImageUrl,
      // );

      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      LoadingOverlay.hide();

      if (mounted) {
        // TODO: Navigate to home screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Farm profile created successfully!'),
            backgroundColor: AppColors.primaryColor,
          ),
        );

        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(builder: (_) => const HomeScreen()),
        //   (route) => false,
        // );
      }
    } catch (e) {
      LoadingOverlay.hide();
      _showError('Failed to create profile: $e');
    }
  }

  Future<void> _skipSetup() async {
    final shouldSkip = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Skip Profile Setup?'),
        content: const Text(
          'You can complete your profile later from settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Skip'),
          ),
        ],
      ),
    );

    if (shouldSkip == true && mounted) {
      // TODO: Navigate to home
      // Navigator.pushAndRemoveUntil(
      //   context,
      //   MaterialPageRoute(builder: (_) => const HomeScreen()),
      //   (route) => false,
      // );
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.lightBackground,
        appBar: AppBar(
          backgroundColor: AppColors.lightBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.greenishBlack),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            'Complete Your Profile',
            style: TextStyle(
              color: AppColors.greenishBlack,
              fontWeight: FontWeight.w600,
            ),
          ),
          actions: [
            TextButton(
              onPressed: _skipSetup,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.grey, fontSize: 14),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  /// Logo
                  RichText(
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Green',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                          ),
                        ),
                        TextSpan(
                          text: 'Eye',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w300,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  /// Profile Picture
                  const Text(
                    "Add Profile Picture",
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    "(Optional)",
                    style: TextStyle(fontSize: 13, color: Colors.grey),
                  ),
                  const SizedBox(height: 12),

                  GestureDetector(
                    onTap: _isUploadingImage ? null : _pickImage,
                    child: _selectedImage != null
                        ? Stack(
                            children: [
                              Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: FileImage(File(_selectedImage!)),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              if (_isUploadingImage)
                                Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.black54,
                                  ),
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              else
                                Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: AppColors.primaryColor,
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.edit,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                  ),
                                ),
                            ],
                          )
                        : UploadBox(
                            label: "+ Upload Image",
                            onTap: _pickImage,
                            isLoading: _isUploadingImage,
                          ),
                  ),

                  const SizedBox(height: 32),

                  const Text(
                    "Farm Information",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 20),

                  /// Farm Name
                  CustomTextField(
                    controller: _name,
                    hint: "Farm Name",
                    validator: SignupValidators.farmName,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  /// Location
                  CustomTextField(
                    controller: _location,
                    hint: "Location",
                    validator: SignupValidators.location,
                    textInputAction: TextInputAction.next,
                  ),
                  const SizedBox(height: 16),

                  /// Area Size with Unit
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: CustomTextField(
                          controller: _areaSize,
                          hint: "Area Size",
                          keyboardType: TextInputType.number,
                          validator: SignupValidators.areaSize,
                          textInputAction: TextInputAction.done,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.grey.withOpacity(0.3),
                            ),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _areaUnit,
                              isExpanded: true,
                              items: ['Feddan', 'Acre', 'Hectare']
                                  .map(
                                    (unit) => DropdownMenuItem(
                                      value: unit,
                                      child: Text(unit),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setState(() {
                                  _areaUnit = value!;
                                });
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Enter the total area of your farm',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),

                  const SizedBox(height: 40),

                  /// Done Button
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      onPressed: _submitForm,
                      child: const Text(
                        "Complete Setup",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
