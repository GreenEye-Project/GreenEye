using GreenEye.Application.DTOs.OtpDtos;
using GreenEye.Application.Responses;

namespace GreenEye.Application.IServices
{
    public interface IOtpService
    {
        Task<OtpResponse> GenerateAndSendOtpAsync(AddOtpDto addOtpDto);

        Task<OtpResponse> UpdateOtpAsync(UpdateOtpDto updateOtpDto);

        Task RemoveOtpAsync(string email);

        Task<bool> ValidateOtp(VerifyOtpDto verifyOtpDto);
    }
}
