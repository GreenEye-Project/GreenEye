using AutoMapper;
using GreenEye.Application.DTOs.OtpDtos;
using GreenEye.Application.IServices;
using GreenEye.Application.Responses;
using GreenEye.Domain.Entities;
using GreenEye.Domain.Interfaces;
using GreenEye.Domain.IRepositories;
using System.Security.Cryptography;
using static System.Net.WebRequestMethods;

namespace GreenEye.Application.Services
{
    public class OtpService(IUnitOfWrok _unitOfWrok,
        IMapper _mapper, IEmailService _emailService, IAppLogger<OtpService> _logger) : IOtpService
    {
        public async Task<OtpResponse> GenerateAndSendOtpAsync(AddOtpDto addOtpDto)
        {
            try
            {
                var mappedData = _mapper.Map<OTP>(addOtpDto);

                mappedData.Code = GenerateOtp();
                mappedData.ExpireAt = DateTime.UtcNow.AddMinutes(5);

                await _unitOfWrok.Otps.AddAsync(mappedData);
                await _unitOfWrok.CompleteAsync();

                await _emailService.SendEmailAsync(mappedData.Email!, "GreenEye", $"Welcome your otp for {mappedData.Type} is {mappedData.Code}");
                _logger.Information($"otp sent to {mappedData.Email} email!");

                return new OtpResponse { Sent = true, ExpireAt = mappedData.ExpireAt};
            }
            catch(Exception ex)
            {
                _logger.Error("unhandeled error, check your internet connection", ex);
                return new OtpResponse { Sent = true };
            }
        }

        public async Task RemoveOtpAsync(string email)
        {
            try
            {
                var otp = await _unitOfWrok.Otps.FindAsync(x => x.Email == email);
                if (otp != null)
                {
                    await _unitOfWrok.Otps.DeleteAsync(otp);
                    await _unitOfWrok.CompleteAsync();
                    _logger.Information("otp removed!");
                }
            }
            catch (Exception ex)
            {
                _logger.Error("error occured when removed otp", ex);
                throw;
            }
           
        }

        public async Task<OtpResponse> UpdateOtpAsync(UpdateOtpDto updateOtpDto)
        {
            try
            {
                var otp = await _unitOfWrok.Otps.FindAsync(x => x.Email == updateOtpDto.Email);
                if (otp is not null && !otp.IsUsed)
                {
                    otp.Code = GenerateOtp();
                    otp.ExpireAt = DateTime.UtcNow.AddMinutes(5);
                    _unitOfWrok.Otps.UpdateAsync(otp);
                    await _unitOfWrok.CompleteAsync();

                    await _emailService.SendEmailAsync(updateOtpDto.Email!, "GreenEye", $"Welcome your otp is {otp.Code}");
                    _logger.Information($"otp sent to {updateOtpDto.Email} email!");
                    return new OtpResponse { Sent = true, ExpireAt = otp.ExpireAt };
                }
                return new OtpResponse { Sent = false };
            }
            catch (Exception ex)
            {
                _logger.Error("error when update otp", ex);
                return new OtpResponse { Sent = false};
            }
        }

        public async Task<bool> ValidateOtp(VerifyOtpDto verifyOtpDto)
        {
            var otp = await _unitOfWrok.Otps.FindAsync(x => x.Email == verifyOtpDto.Email);
            if (otp is not null && !otp.IsUsed && otp.Code == verifyOtpDto.Code && otp.ExpireAt > DateTime.UtcNow)
            {
                otp.IsUsed = true;
                await _unitOfWrok.CompleteAsync();
                return true;
            }

            return false;
        }

        private string GenerateOtp()
        {
            return RandomNumberGenerator
                .GetInt32(100000, 1000000)
                .ToString();
        }

    }
}
