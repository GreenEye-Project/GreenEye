class ApiEndpoints {
  static const String baseUrl = 'https://greeneyeaifeatures.runasp.net';
  static const String login = '/api/Authentication/login';
  static const String register = '/api/Authentication/register';
  static const String verifyEmail = '/api/Authentication/verify-otp';
  static const String resendOtp = '/api/Authentication/resend-otp';
  static const String forgotPassword = '/api/Authentication/forgot-password';
  static const String resetPassword = '/api/Authentication/reset-password';
  static const String revokeToken = '/api/Authentication/revoke-token';
  static const String refreshToken = '/api/Authentication/refresh-token';
  static const String changePassword = '/api/Authentication/change-password';
  static const String profile = '/api/User/profile';
  static const String cropDisease = '/api/CropDisease';
  static const String cropHistory = '/api/CropDisease/history';
  static const String classification = '/api/CropDisease/Classification';
  static const String forecasting = '/api/Forecasting/forecast';
  static const String cropRecommendation = '/api/CropRecommendation/recommend';
}