import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../shared/widgets/inputs/outlined_rich_text.dart';
import '../bloc/signup_bloc.dart';
import '../bloc/signup_event.dart';
import '../bloc/signup_state.dart';
import '/core/utils/validators.dart';
import '/core/utils/input_formatters.dart';
import '/core/models/user_role.dart';
import '/core/theme/app_colors.dart';
import '/shared/widgets/inputs/custom_text_field.dart';
import '/shared/widgets/inputs/password_strength_indicator.dart';
import '/shared/widgets/inputs/loading_overlay.dart';
import '../../otp/verify_otp_screen.dart';
import '../../login/login_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final address = TextEditingController();
  final password = TextEditingController();
  final confirmPassword = TextEditingController();

  // Focus nodes for keyboard navigation
  final _nameFocus = FocusNode();
  final _phoneFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _addressFocus = FocusNode();
  final _passwordFocus = FocusNode();
  final _confirmPasswordFocus = FocusNode();

  int selectedRole = UserRole.farmer;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    name.dispose();
    phone.dispose();
    email.dispose();
    address.dispose();
    password.dispose();
    confirmPassword.dispose();
    _nameFocus.dispose();
    _phoneFocus.dispose();
    _emailFocus.dispose();
    _addressFocus.dispose();
    _passwordFocus.dispose();
    _confirmPasswordFocus.dispose();
    super.dispose();
  }

  Future<bool> _onWillPop() async {
    // Check if user has entered any data
    if (name.text.isNotEmpty ||
        phone.text.isNotEmpty ||
        email.text.isNotEmpty ||
        address.text.isNotEmpty ||
        password.text.isNotEmpty) {
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

  // ignore: unused_element
  String _getRoleName(int role) {
    switch (role) {
      case 1: // UserRole.farmer
        return 'Farmer';
      case 2: // UserRole.expert
        return 'Expert';
      case 3: // UserRole.supplier
        return 'Supplier';
      default:
        return 'Farmer';
    }
  }

  IconData _getRoleIcon(int role) {
    switch (role) {
      case 1: // UserRole.farmer
        return Icons.agriculture;
      case 2: // UserRole.expert
        return Icons.person_outline;
      case 3: // UserRole.supplier
        return Icons.business;
      default:
        return Icons.agriculture;
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        backgroundColor: AppColors.background,
        body: BlocConsumer<SignupBloc, SignupState>(
          listener: (context, state) {
            if (state is SignupLoading) {
              LoadingOverlay.show(context, message: 'Creating account...');
            } else {
              LoadingOverlay.hide();
            }

            if (state is SignupSuccess) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) =>
                      VerifyOtpScreen(email: state.email, role: state.role),
                ),
              );
            }

            if (state is SignupFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 60),

                      /// App Logo
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

                      const SizedBox(height: 30),

                      const Text(
                        'Sign Up',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.greenishBlack,
                        ),
                        semanticsLabel: 'Create Account Page',
                      ),

                      const SizedBox(height: 24),

                      /// Name Field
                      CustomTextField(
                        controller: name,
                        hint: "Name",
                        validator: SignupValidators.name,
                        textInputAction: TextInputAction.next,
                        focusNode: _nameFocus,
                        onSubmitted: (_) => _phoneFocus.requestFocus(),
                      ),
                      const SizedBox(height: 16),

                      /// Phone Field with Formatting
                      CustomTextField(
                        controller: phone,
                        hint: "Phone Number",
                        validator: SignupValidators.phone,
                        keyboardType: TextInputType.phone,
                        textInputAction: TextInputAction.next,
                        focusNode: _phoneFocus,
                        inputFormatters: [PhoneInputFormatter()],
                        onSubmitted: (_) => _emailFocus.requestFocus(),
                      ),
                      const SizedBox(height: 16),

                      /// Email Field
                      CustomTextField(
                        controller: email,
                        hint: "Email Address",
                        validator: SignupValidators.email,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        focusNode: _emailFocus,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSubmitted: (_) => _addressFocus.requestFocus(),
                      ),
                      const SizedBox(height: 16),

                      /// Password Field
                      CustomTextField(
                        controller: password,
                        hint: "Password",
                        obscureText: _obscurePassword,
                        validator: SignupValidators.password,
                        textInputAction: TextInputAction.next,
                        focusNode: _passwordFocus,
                        onChanged: (_) => setState(() {}),
                        onSubmitted: (_) =>
                            _confirmPasswordFocus.requestFocus(),
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
                      PasswordStrengthIndicator(password: password.text),

                      const SizedBox(height: 16),

                      /// Confirm Password Field
                      CustomTextField(
                        controller: confirmPassword,
                        hint: "Confirm Password",
                        obscureText: _obscureConfirmPassword,
                        validator: (v) =>
                            SignupValidators.confirmPassword(v, password.text),
                        textInputAction: TextInputAction.done,
                        focusNode: _confirmPasswordFocus,
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

                      const SizedBox(height: 16),

                      /// Role Selection Dropdown
                      DropdownButtonFormField<int>(
                        value: selectedRole,
                        decoration: InputDecoration(
                          hintText: 'Choose Your Role',
                          prefixIcon: Icon(
                            _getRoleIcon(selectedRole),
                            color: AppColors.primaryColor,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(
                              color: Colors.grey.shade300,
                              width: 1,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(
                              color: AppColors.primaryColor,
                              width: 2,
                            ),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 16,
                          ),
                        ),
                        items: [
                          DropdownMenuItem(
                            value: UserRole.farmer,
                            child: Row(
                              children: const [
                                SizedBox(width: 12),
                                Text('Farmer'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: UserRole.expert,
                            child: Row(
                              children: const [
                                SizedBox(width: 12),
                                Text('Expert'),
                              ],
                            ),
                          ),
                          DropdownMenuItem(
                            value: UserRole.supplier,
                            child: Row(
                              children: const [
                                SizedBox(width: 12),
                                Text('Supplier'),
                              ],
                            ),
                          ),
                        ],
                        onChanged: (value) {
                          if (value != null) {
                            setState(() {
                              selectedRole = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Please select a role';
                          }
                          return null;
                        },
                      ),

                      const SizedBox(height: 24),

                      /// Signup Button
                      SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton(
                          onPressed: () {
                            if (!_formKey.currentState!.validate()) return;

                            context.read<SignupBloc>().add(
                              SignupSubmitted(
                                name: name.text.trim(),
                                phone: phone.text.trim(),
                                email: email.text.trim(),
                                address: address.text.trim(),
                                password: password.text,
                                confirmPassword: confirmPassword.text,
                                role: selectedRole,
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryColor,
                            disabledBackgroundColor: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Sign Up',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                            semanticsLabel: 'Sign Up Button',
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      /// Terms & Conditions Text
                      Wrap(
                        alignment: WrapAlignment.center,
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Center(
                            child: const Text(
                              'By signing up, you agree to our',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: Navigate to Terms & Conditions
                            },
                            child: Center(
                              child: const Text(
                                'Terms & Conditions',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: AppColors.primaryColor,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// Login Link
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Already have an account? ",
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.darkGrey,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              );
                            },
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.primaryColor,
                                fontWeight: FontWeight.w600,
                              ),
                              semanticsLabel: 'Go to Login',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
