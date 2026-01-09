import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:async';

import '../../../shared/widgets/inputs/outlined_rich_text.dart';
import './otp_controller.dart';
import '/core/theme/app_colors.dart';
import '/core/models/user_role.dart';
import '/features/auth/reset_password/reset_password_screen.dart';
import '/features/auth/signup/screens/farmer_setup_screen.dart';
import '/features/auth/signup/screens/expert_setup_screen.dart';
import '/features/auth/signup/screens/supplier_setup_screen.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;
  final int role;

  const VerifyOtpScreen({super.key, required this.email, required this.role});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final TextEditingController _codeController = TextEditingController();

  int _resendCountdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _codeController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _startResendCountdown() {
    setState(() => _resendCountdown = 60);
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown > 0) {
        setState(() => _resendCountdown--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OtpController(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: Consumer<OtpController>(
          builder: (context, controller, _) {
            _handleMessages(context, controller);

            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 80),

                    /// Logo
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
                          /// Title
                          const Text(
                            "Verify it’s you",
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w700,
                              color: AppColors.darkGreenish,
                            ),
                          ),

                          const SizedBox(height: 12),

                          /// Description
                          const Text(
                            "Please enter the verification code send to your email, "
                            "if you don’t see it ,check your spam folder",
                            style: TextStyle(
                              fontSize: 16,
                              height: 1.5,
                              fontWeight: FontWeight.w400,
                              color: AppColors.greenishBlack,
                            ),
                          ),

                          const SizedBox(height: 24),

                          /// OTP Input
                          TextField(
                            controller: _codeController,
                            keyboardType: TextInputType.number,
                            maxLength: 6,
                            decoration: InputDecoration(
                              hintText: 'Enter Code',
                              hintStyle: TextStyle(
                                color: AppColors.grey,
                                fontSize: 16,
                              ),
                              counterText: '',
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: const BorderSide(
                                  color: AppColors.primaryColor,
                                  width: 2,
                                ),
                              ),
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

                              /// Verify
                              SizedBox(
                                height: 45,
                                width: 140,
                                child: ElevatedButton(
                                  onPressed: controller.isLoading
                                      ? null
                                      : () => _verifyOtp(context, controller),
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
                                          'Verify',
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

                          const SizedBox(height: 20),

                          /// Resend
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'Not in inbox or spam folder? ',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.darkGrey,
                                  ),
                                ),
                                if (_resendCountdown > 0)
                                  Text(
                                    'Resend in $_resendCountdown s',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.grey,
                                    ),
                                  )
                                else
                                  GestureDetector(
                                    onTap: controller.isResending
                                        ? null
                                        : () => _resendOtp(context, controller),
                                    child: const Text(
                                      'Resend',
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primaryColor,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _handleMessages(BuildContext context, OtpController controller) {
    if (controller.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.errorMessage!),
            backgroundColor: Colors.red,
          ),
        );
        controller.clearMessages();
      });
    }

    if (controller.successMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(controller.successMessage!),
            backgroundColor: AppColors.primaryColor,
          ),
        );
        controller.clearMessages();
      });
    }
  }

  Future<void> _verifyOtp(
    BuildContext context,
    OtpController controller,
  ) async {
    if (_codeController.text.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter the 6-digit code'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    final success = await controller.verifyOtp(
      email: widget.email,
      code: _codeController.text,
      type: OtpType.signup,
    );

    if (success && mounted) {
      _navigate(context);
    }
  }

  Future<void> _resendOtp(
    BuildContext context,
    OtpController controller,
  ) async {
    final success = await controller.resendOtp(
      email: widget.email,
      type: OtpType.signup,
    );

    if (success) {
      _startResendCountdown();
    }
  }

  void _navigate(BuildContext context) {
    Widget next;

    if (widget.role == 0) {
      next = ResetPasswordScreen(email: widget.email);
    } else if (widget.role == UserRole.farmer) {
      next = const FarmerSetupScreen();
    } else if (widget.role == UserRole.supplier) {
      next = const SupplierSetupScreen();
    } else {
      next = const ExpertSetupScreen();
    }

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => next));
  }
}
