using GreenEye.Application.DTOs.AuthDtos.OtpDtos;
using GreenEye.Application.DTOs.AuthDtos.RegisterDtos;
using GreenEye.Application.IServices.Authentication;
using GreenEye.Presentation.Response;
using Microsoft.AspNetCore.Mvc;

namespace GreenEye.Presentation.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthenticationController(IAuthenticationService _authService) : ControllerBase
    {
        [HttpPost("register")]
        public async Task<ActionResult<GeneralResponse<OtpResult>>> Register(RegisterDto registerDto)
        {
            if(!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _authService.RegisterAsync(registerDto);
            
            return result.Sent ? Ok(new GeneralResponse<OtpResult>
            {
                IsSuccess = true,
                Message = "OTP sent to your email",
                Data = result
            }) : BadRequest();
        }

        [HttpPost("verify-otp")]
        public async Task<ActionResult<GeneralResponse<AuthResult>>> verifyOtp(VerifyOtpDto verifyOtpDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _authService.VerifyOtp(verifyOtpDto);
            return Ok(new GeneralResponse<AuthResult>
            {
                IsSuccess = true,
                Message = result.Message,
                Data = result.Data
            });
        }

        [HttpPost("login")]
        public async Task<ActionResult<GeneralResponse<AuthResult>>> Login(LoginDto loginDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _authService.Login(loginDto);

            return Ok(new GeneralResponse<AuthResult>
            {
                IsSuccess = true,
                Data = result
            });
        }

        [HttpPost("resend-otp")]
        public async Task<ActionResult<GeneralResponse<OtpResult>>> ResendOtp(ResendOtpDto resendOtpDto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _authService.ResendOtpAsync(resendOtpDto);

            return Ok(new GeneralResponse<OtpResult>
            {
                IsSuccess = true,
                Message = "Otp code send to your email",
                Data = result
            });
        }

        [HttpPost("forget-password")]
        public async Task<ActionResult<GeneralResponse<OtpResult>>> ForgetPassword(string email)
        {
            var result = await _authService.ForgetPassword(email);
           
            return result.Sent ? Ok(new GeneralResponse<OtpResult>
            {
                IsSuccess = true,
                Message = "Check for OTP in your email",
                Data = result
            }) : BadRequest();
        }

        [HttpPost("reset-password")]
        public async Task<ActionResult<GeneralResponse<string>>> ResetPassword(ResetPasswordDto dto)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            var result = await _authService.ResetPasswordAsync(dto);
            if (!result)
                return BadRequest();
            return Ok(new GeneralResponse<string>
            {
                IsSuccess = true,
                Message = "Password Changed!"
            });
        }

        [HttpPost("refresh-token")]
        public async Task<ActionResult<GeneralResponse<AuthResult>>> RefreshToken(string token)
        {
            var result = await _authService.RefreshTokenAsync(token);

            return Ok(new GeneralResponse<AuthResult>
            {
                IsSuccess = true,
                Data = result
            });
        }

        [HttpPost("revoke-token")]
        public async Task<ActionResult<GeneralResponse<string>>> RevokeToken(string token)
        {
            await _authService.RevokeTokenAsync(token);
            return Ok(new GeneralResponse<string>
            {
                IsSuccess = true,
                Message = "Token became revoked!"
            });
        }
    }
}
