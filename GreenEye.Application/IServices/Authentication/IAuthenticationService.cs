using GreenEye.Application.DTOs.AuthDtos.OtpDtos;
using GreenEye.Application.DTOs.AuthDtos.RegisterDtos;

namespace GreenEye.Application.IServices.Authentication
{
    public interface IAuthenticationService
    {
        Task<OtpResult> RegisterAsync(RegisterDto registerDto);
        Task<VerifyOtpResult<AuthResult>> VerifyOtp(VerifyOtpDto verifyOtpDto);
        Task<AuthResult> Login(LoginDto loginDto);
        Task<OtpResult> ResendOtpAsync(ResendOtpDto resendOtpDto);
        Task<OtpResult> ForgetPassword(string email);
        Task<bool> ResetPasswordAsync(ResetPasswordDto resetPasswordDto);
        Task<AuthResult> RefreshTokenAsync(string token);
        Task RevokeTokenAsync(string token);
    }
}
