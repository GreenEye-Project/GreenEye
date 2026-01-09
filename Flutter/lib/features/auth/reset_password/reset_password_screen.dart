import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/inputs/outlined_rich_text.dart';
import './reset_password_controller.dart';
import '/core/utils/validators.dart';
import '/core/theme/app_colors.dart';
import '/shared/widgets/inputs/custom_text_field.dart';
import '/shared/widgets/inputs/password_strength_indicator.dart';
import '/shared/widgets/inputs/loading_overlay.dart';
import '../login/login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({super.key, required this.email});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ResetPasswordController(email: widget.email),
      child: Consumer<ResetPasswordController>(
        builder: (context, controller, _) {
          return Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    children: [
                      SizedBox(height: 80),

                      /// LOGO
                      OutlinedRichText(
                        strokeColor: AppColors.grey,
                        strokeWidth: 2,
                        spans: const [
                          TextSpan(
                            text: 'Green',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryColor,
                            ),
                          ),
                          TextSpan(
                            text: 'Eye',
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.w400,
                              color: AppColors.secondaryColor,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      /// Card
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Color(0xFFFCFCFC),
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Icon and Title
                            Row(
                              children: [
                                Container(
                                  width: 56,
                                  height: 56,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryColor.withOpacity(
                                      0.1,
                                    ),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.lock_reset,
                                    size: 28,
                                    color: AppColors.primaryColor,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                const Expanded(
                                  child: Text(
                                    'Create New Password',
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.darkGreenish,
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 16),

                            /// Description
                            const Text(
                              'Your new password must be different from previously used passwords',
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                fontWeight: FontWeight.w400,
                                color: AppColors.greenishBlack,
                              ),
                            ),

                            const SizedBox(height: 24),

                            /// NEW PASSWORD
                            CustomTextField(
                              controller: controller.newPasswordController,
                              hint: 'New Password',
                              obscureText: _obscurePassword,
                              validator: SignupValidators.password,
                              textInputAction: TextInputAction.next,
                              onChanged: (_) => setState(() {}),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                            ),

                            /// Password Strength Indicator
                            PasswordStrengthIndicator(
                              password: controller.newPasswordController.text,
                            ),

                            const SizedBox(height: 16),

                            /// CONFIRM PASSWORD
                            CustomTextField(
                              controller: controller.confirmPasswordController,
                              hint: 'Confirm New Password',
                              obscureText: _obscureConfirmPassword,
                              validator: (v) =>
                                  SignupValidators.confirmPassword(
                                    v,
                                    controller.newPasswordController.text,
                                  ),
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) => _submit(context, controller),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscureConfirmPassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscureConfirmPassword =
                                        !_obscureConfirmPassword;
                                  });
                                },
                              ),
                            ),

                            const SizedBox(height: 24),

                            /// Buttons Row
                            Row(
                              children: [
                                /// Cancel
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text(
                                    'Cancel',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.darkGreenish,
                                    ),
                                  ),
                                ),

                                const Spacer(),

                                /// Reset Button
                                SizedBox(
                                  height: 45,
                                  width: 140,
                                  child: ElevatedButton(
                                    onPressed: controller.isLoading
                                        ? null
                                        : () => _submit(context, controller),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppColors.primaryColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(14),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: controller.isLoading
                                        ? const SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              color: Colors.white,
                                            ),
                                          )
                                        : const Text(
                                            'Reset',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future<void> _submit(
    BuildContext context,
    ResetPasswordController controller,
  ) async {
    if (!controller.formKey.currentState!.validate()) return;

    LoadingOverlay.show(context, message: 'Resetting password...');

    final success = await controller.submit();

    LoadingOverlay.hide();

    if (success && context.mounted) {
      // Show success message
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primaryColor, size: 28),
              SizedBox(width: 12),
              Text(
                'Success!',
                style: TextStyle(
                  color: AppColors.darkGreenish,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          content: const Text(
            'Your password has been reset successfully. Please login with your new password.',
            style: TextStyle(fontSize: 16, color: AppColors.greenishBlack),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primaryColor,
              ),
              child: const Text(
                'OK',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      );

      // Navigate to login
      if (context.mounted) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const LoginScreen()),
          (route) => false,
        );
      }
    } else if (controller.errorMessage != null && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(controller.errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
