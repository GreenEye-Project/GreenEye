using AutoMapper;
using GreenEye.Application.DTOs.AuthDtos.OtpDtos;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices;
using GreenEye.Application.IServices.Authentication;
using GreenEye.Domain.Entities;
using GreenEye.Domain.Interfaces;
using GreenEye.Domain.Interfaces.IRepositories.Generics;
using System.Diagnostics;
using System.Security.Cryptography;

namespace GreenEye.Application.Services.Authentication
{
    public class OtpService(IUnitOfWrok _unitOfWrok,
        IMapper _mapper, IEmailService _emailService, IAppLogger<OtpService> _logger) : IOtpService
    {
        public async Task<OtpResult> GenerateAndSendOtpAsync(AddOtpDto addOtpDto)
        {
            try
            {
                var mappedData = _mapper.Map<OTP>(addOtpDto);

                mappedData.Code = GenerateOtp();
                mappedData.ExpireAt = DateTime.UtcNow.AddMinutes(5);

                await _unitOfWrok.Otps.AddAsync(mappedData);
                await _unitOfWrok.CompleteAsync();
                _logger.Information($"OTP added!");

                // Calculate time for sending email
                var sw = Stopwatch.StartNew();
                _logger.Information($"Before sending email took {sw.ElapsedMilliseconds} ms");

                await _emailService.SendEmailAsync(mappedData.Email!, "GreenEye", $"Welcome your otp for {mappedData.Type} is {mappedData.Code}");
                _logger.Information($"After sending email took {sw.ElapsedMilliseconds} ms");

                _logger.Information($"OTP sent to {mappedData.Email} email!");

                return new OtpResult { Sent = true, ExpireAt = mappedData.ExpireAt.ToLocalTime()};
            }
            catch(Exception ex)
            {
                _logger.Error("unhandeled error, check your internet connection", ex);
                return new OtpResult { Sent = false };
            }
        }

        public async Task RemoveOtpAsync(string email)
        {
            try
            {
                var otp = await _unitOfWrok.Otps.FindAsync(x => x.Email == email);
                if (otp != null)
                {
                    await _unitOfWrok.Otps.DeleteAsync(x => x.Email == email);
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

        public async Task<OtpResult> UpdateOtpAsync(UpdateOtpDto updateOtpDto)
        {
            try
            {
                var otp = await _unitOfWrok.Otps.FindAsync(x => x.Email == updateOtpDto.Email);
                if (otp == null)
                {
                    var addOtp = new AddOtpDto
                    {
                        Email = updateOtpDto.Email,
                        Type = updateOtpDto.Type
                    };
                    return await GenerateAndSendOtpAsync(addOtp);
                }

                if (!otp.IsUsed && otp.Type == updateOtpDto.Type)
                {
                    otp.Code = GenerateOtp();
                    otp.ExpireAt = DateTime.UtcNow.AddMinutes(5);
                    _unitOfWrok.Otps.UpdateAsync(otp);
                    await _unitOfWrok.CompleteAsync();

                    // Calculate time for sending email
                    var sw = Stopwatch.StartNew();
                    _logger.Information($"Before sending email took {sw.ElapsedMilliseconds} ms");

                    await _emailService.SendEmailAsync(updateOtpDto.Email!, "GreenEye", $"Welcome your otp is {otp.Code}");
                    _logger.Information($"After sending email took {sw.ElapsedMilliseconds} ms");

                    _logger.Information($"otp sent to {updateOtpDto.Email} email!");

                    return new OtpResult { Sent = true, ExpireAt = otp.ExpireAt.ToLocalTime() };
                }
                throw new BusinessException("Check for otp type");
            }
            catch (BusinessException)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.Error("error when update otp", ex);
                return new OtpResult { Sent = false };
            }
        }

        public async Task<bool> ValidateOtp(VerifyOtpDto verifyOtpDto)
        {
            var otp = await _unitOfWrok.Otps.FindAsync(x => x.Email == verifyOtpDto.Email);
            if (otp == null)
                return false;

            if (otp is not null && !otp.IsUsed && otp.Code == verifyOtpDto.Code && otp.ExpireAt > DateTime.UtcNow)
            {
                otp.IsUsed = true;
                await _unitOfWrok.CompleteAsync();
                return true;
            }

            if (otp!.Type != verifyOtpDto.Type)
                throw new BusinessException("Check for otp type");

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
