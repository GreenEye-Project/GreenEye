import 'package:flutter/material.dart';
import '../data/auth_repository.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository = AuthRepository();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool rememberMe = true;
  bool isLoading = false;
  String? errorMessage;

  final formKey = GlobalKey<FormState>();

  Future<bool> login() async {
    if (!formKey.currentState!.validate()) return false;

    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final result = await _authRepository.login(
        email: emailController.text.trim(),
        password: passwordController.text,
        rememberMe: rememberMe,
      );

      print('✅ Login successful in controller!');
      print('📦 User data: ${result['name'] ?? 'No name'}');

      isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Login failed in controller: $e');
      isLoading = false;
      errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
