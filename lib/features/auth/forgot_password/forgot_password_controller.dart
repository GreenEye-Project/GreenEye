import 'package:flutter/material.dart';
import '../data/auth_repository.dart';

class ForgotPasswordController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;
  String? errorMessage;

  Future<bool> submit() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.forgotPassword(email: emailController.text.trim());

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
    emailController.dispose();
    super.dispose();
  }
}
