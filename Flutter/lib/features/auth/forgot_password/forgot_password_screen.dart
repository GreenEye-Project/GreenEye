import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../shared/widgets/inputs/outlined_rich_text.dart';
import './forgot_password_controller.dart';
import '/core/utils/validators.dart';
import '/core/theme/app_colors.dart';
import '/shared/widgets/inputs/custom_text_field.dart';
import '/shared/widgets/inputs/loading_overlay.dart';
import '../otp/verify_otp_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ForgotPasswordController(),
      child: const _ForgotPasswordView(),
    );
  }
}

class _ForgotPasswordView extends StatelessWidget {
  const _ForgotPasswordView();

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<ForgotPasswordController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: controller.formKey,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.12),

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
                              color: AppColors.primaryColor.withOpacity(0.1),
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
                              'Forgot Password?',
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
                        "No worries! Enter your email and we'll send you a reset code",
                        style: TextStyle(
                          fontSize: 16,
                          height: 1.5,
                          fontWeight: FontWeight.w400,
                          color: AppColors.greenishBlack,
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// EMAIL
                      CustomTextField(
                        controller: controller.emailController,
                        hint: 'Email Address',
                        keyboardType: TextInputType.emailAddress,
                        validator: AuthValidators.email,
                        textInputAction: TextInputAction.done,
                        onSubmitted: (_) => _submit(context, controller),
                      ),

                      const SizedBox(height: 24),

                      /// Buttons Row
                      Row(
                        children: [
                          /// Back to Login
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text(
                              'Back to Login',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.darkGreenish,
                              ),
                            ),
                          ),

                          const Spacer(),

                          /// Send Code Button
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
                                      'Send Code',
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
  }

  Future<void> _submit(
    BuildContext context,
    ForgotPasswordController controller,
  ) async {
    if (!controller.formKey.currentState!.validate()) return;

    // Show loading overlay
    LoadingOverlay.show(context, message: 'Sending reset code...');

    final success = await controller.submit();

    LoadingOverlay.hide();

    if (success && context.mounted) {
      // Navigate to OTP screen for password reset
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VerifyOtpScreen(
            email: controller.emailController.text.trim(),
            role: 0, // Indicate password reset flow
          ),
        ),
      );
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
