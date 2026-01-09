import 'package:flutter/material.dart';
import '../data/otp_repository.dart';
import '/core/network/session_manager.dart';

enum OtpType {
  signup(1),
  passwordReset(2);

  final int value;
  const OtpType(this.value);
}

class OtpController extends ChangeNotifier {
  final OtpRepository _repository = OtpRepository();

  bool _isLoading = false;
  bool _isResending = false;
  String? _errorMessage;
  String? _successMessage;

  bool get isLoading => _isLoading;
  bool get isResending => _isResending;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  /// Verify OTP and save tokens
  Future<bool> verifyOtp({
    required String email,
    required String code,
    required OtpType type,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _repository.verifyOtp(
        email: email,
        code: code,
        type: type.value,
      );

      if (response['isSuccess'] == true && response['data'] != null) {
        final data = response['data'];
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        if (accessToken == null) {
          _errorMessage = 'Invalid response from server';
          _isLoading = false;
          notifyListeners();
          return false;
        }

        // Save tokens
        await SessionManager.saveTokens(
          accessToken: accessToken,
          refreshToken: refreshToken ?? '',
        );

        _successMessage = response['message'] ?? 'Verification successful';
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Verification failed';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Resend OTP code
  Future<bool> resendOtp({required String email, required OtpType type}) async {
    _isResending = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final response = await _repository.resendOtp(
        email: email,
        type: type.value,
      );

      if (response['isSuccess'] == true) {
        _successMessage = response['message'] ?? 'OTP sent successfully';
        _isResending = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = response['message'] ?? 'Failed to resend OTP';
        _isResending = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isResending = false;
      notifyListeners();
      return false;
    }
  }

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }
}
