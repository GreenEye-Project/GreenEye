using GreenEye.Application.DTOs.AuthDtos.OtpDtos;

namespace GreenEye.Application.IServices.Authentication
{
    public interface IOtpService
    {
        Task<OtpResult> GenerateAndSendOtpAsync(AddOtpDto addOtpDto);

        Task<OtpResult> UpdateOtpAsync(UpdateOtpDto updateOtpDto);

        Task RemoveOtpAsync(string email);

        Task<bool> ValidateOtp(VerifyOtpDto verifyOtpDto);
    }
}
