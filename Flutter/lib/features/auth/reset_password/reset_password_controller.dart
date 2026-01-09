import 'package:flutter/material.dart';
import '../data/auth_repository.dart';

class ResetPasswordController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();
  final String email;

  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String? errorMessage;

  ResetPasswordController({required this.email});

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      // ✅ Only send newPassword, not confirmPassword
      await _authRepository.resetPassword(
        email: email,
        newPassword: newPasswordController.text,
      );

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      errorMessage = e.toString();
      isLoading = false;
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
