import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/shared/widgets/inputs/custom_text_field.dart';
import '/shared/widgets/inputs/upload_box.dart';
import '/core/theme/app_colors.dart';

class ExpertSetupScreen extends StatefulWidget {
  const ExpertSetupScreen({super.key});

  @override
  State<ExpertSetupScreen> createState() => _ExpertSetupScreenState();
}

class _ExpertSetupScreenState extends State<ExpertSetupScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _locationController = TextEditingController();
  final _specializationController = TextEditingController();
  final _experienceController = TextEditingController();
  final _bioController = TextEditingController();

  String? _selectedImage;
  bool _isLoading = false;

  final _picker = ImagePicker();

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _specializationController.dispose();
    _experienceController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _selectedImage = pickedFile.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error picking image: $e')));
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    setState(() {
      _isLoading = false;
    });

    // TODO: Navigate to home
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Expert profile setup completed!'),
          backgroundColor: AppColors.primaryColor,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightBackground,
      appBar: AppBar(
        backgroundColor: AppColors.lightBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.greenishBlack),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Setup Your Profile',
          style: TextStyle(
            color: AppColors.greenishBlack,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                /// Progress Indicator
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildProgressDot(true),
                    _buildProgressLine(true),
                    _buildProgressDot(false),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Step 1 of 2',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 32),

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

                const SizedBox(height: 24),

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
                  onTap: _pickImage,
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
                      : UploadBox(label: "+ Upload Image", onTap: _pickImage),
                ),

                const SizedBox(height: 28),

                const Text(
                  "Professional Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 20),

                /// Full Name
                CustomTextField(
                  controller: _nameController,
                  hint: "Full Name",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                /// Location
                CustomTextField(
                  controller: _locationController,
                  hint: "Location",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                /// Specialization
                CustomTextField(
                  controller: _specializationController,
                  hint: "Specialization",
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter your specialization';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'e.g., Plant Pathology, Soil Science, Crop Management',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),

                /// Years of Experience
                CustomTextField(
                  controller: _experienceController,
                  hint: "Years of Experience",
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter years of experience';
                    }
                    if (int.tryParse(value) == null) {
                      return 'Please enter a valid number';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 16),

                /// Bio
                CustomTextField(
                  controller: _bioController,
                  hint: "Professional Bio",
                  maxLines: 4,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Please enter a brief bio';
                    }
                    if (value.trim().length < 50) {
                      return 'Bio should be at least 50 characters';
                    }
                    return null;
                  },
                  textInputAction: TextInputAction.done,
                ),
                const SizedBox(height: 8),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Tell farmers about your expertise and experience (min 50 characters)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ),

                const SizedBox(height: 32),

                /// Submit Button
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
                    onPressed: _isLoading ? null : _submitForm,
                    child: _isLoading
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Text(
                            "Continue",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),

                const SizedBox(height: 16),

                /// Skip Button
                if (_selectedImage == null)
                  TextButton(
                    onPressed: () {
                      // TODO: Skip to next step
                    },
                    child: const Text(
                      'Skip for now',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressDot(bool isActive) {
    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      width: 40,
      height: 2,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      color: isActive ? AppColors.primaryColor : Colors.grey.shade300,
    );
  }
}
