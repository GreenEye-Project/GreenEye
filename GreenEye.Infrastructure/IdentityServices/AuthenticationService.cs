using GreenEye.Application.DTOs.AuthDtos.OtpDtos;
using GreenEye.Application.DTOs.AuthDtos.RegisterDtos;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices;
using GreenEye.Application.IServices.Authentication;
using GreenEye.Domain.Entities;
using GreenEye.Domain.Enums;
using GreenEye.Domain.Interfaces;
using GreenEye.Domain.Interfaces.IRepositories;
using GreenEye.Infrastructure.Entities.IdentityModel;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace GreenEye.Infrastructure.IdentityServices
{
    public class AuthenticationService(UserManager<ApplicationUser> _userManager,
        IImageService _imageService, IOtpService _otpService, IUnitOfWrok _unitOfWork,
        IConfiguration configuration, RoleManager<IdentityRole> _roleManager,
        IAppLogger<AuthenticationService> _logger) : IAuthenticationService
    {
        // Password hashed, identity validation
        public async Task<OtpResult> RegisterAsync(RegisterDto registerDto)
        {
            try
            {
                var getUserByEmail = await _userManager.FindByEmailAsync(registerDto.Email!);
                if (getUserByEmail != null)
                    throw new BusinessException("Can not create account for this email");

                #region validation of user data
                // Verify identity validation(before move to verify otp page)
                var user = new ApplicationUser
                {
                    Email = registerDto.Email,
                    UserName = registerDto.Name,
                    PhoneNumber = registerDto.PhoneNumber,
                    Address = registerDto.Address,
                };

                var checkUsernameValidate = await _userManager.UserValidators.First().ValidateAsync(_userManager, user);
                var checkPasswordValidate = await _userManager.PasswordValidators.First().ValidateAsync(_userManager, user, registerDto.Password);

                // Display validations errors if found
                if (!checkUsernameValidate.Succeeded)
                {
                    foreach (var error in checkUsernameValidate.Errors)
                        throw new BusinessException($"{error.Description}");
                }
                if (!checkPasswordValidate.Succeeded)
                {
                    foreach (var error in checkPasswordValidate.Errors)
                        throw new BusinessException($"{error.Description}");
                }
                #endregion

                string uploadImage = string.Empty;
                if (registerDto.Role == Roles.Supplier)
                    uploadImage = await _imageService.UploadImageAsync(registerDto.ImageFile!, "supplier-images");

                else if (registerDto.Role == Roles.Expert)
                    uploadImage = await _imageService.UploadImageAsync(registerDto.ImageFile!, "expert-images");

                else
                    uploadImage = await _imageService.UploadImageAsync(registerDto.ImageFile!, "farmer-images");

                var tempUser = new TempUser
                {
                    Email = registerDto.Email,
                    Name = registerDto.Name,
                    PhoneNumber = registerDto.PhoneNumber,
                    Address = registerDto.Address,
                    ImageUrl = uploadImage,
                    Password = registerDto.Password,
                    Role = registerDto.Role
                };
                await _unitOfWork.TempUsers.AddAsync(tempUser);
                await _unitOfWork.CompleteAsync();

                var addOtp = new AddOtpDto
                {
                    Email = registerDto.Email,
                    Type = OtpTypes.EmailVerification
                };

                return await _otpService.GenerateAndSendOtpAsync(addOtp);
            }
            catch (BusinessException)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.Error(ex.Message, ex);
                throw;
            }
        }

        public async Task<VerifyOtpResult<AuthResult>> VerifyOtp(VerifyOtpDto dto)
        {
            var isValid = await _otpService.ValidateOtp(dto);
            if (!isValid)
                throw new BusinessException("Invalid or expired otp");

            switch (dto.Type)
            {
                case OtpTypes.EmailVerification:
                    var authResult = await CreateUserAsync(dto.Email!);
                    await _otpService.RemoveOtpAsync(dto.Email!);
                    return new VerifyOtpResult<AuthResult> { Data = authResult.Data, Message = authResult.Message};

                case OtpTypes.ResetPassword:
                    await _otpService.RemoveOtpAsync(dto.Email!);
                    return new VerifyOtpResult<AuthResult>
                    {
                        Message = "OTP verified successfully"
                    };

                default:
                    throw new BusinessException("Invalid OTP type");
            }
        }

        public async Task<VerifyOtpResult<AuthResult>> CreateUserAsync(string email)
        {
            var tempUser = await _unitOfWork.TempUsers.FindAsync(x => x.Email == email);
            if (tempUser is null)
                throw new BusinessException("Error occurred, confirm your registration");

            if ((tempUser.Role == Roles.Expert || tempUser.Role == Roles.Supplier) && !tempUser.IsApproved)
                return new VerifyOtpResult<AuthResult> { Message = "Admin review your data, and will send email for you" };

            var roleName = Enum.GetName(typeof(Roles), tempUser.Role)
                ?? throw new BusinessException("Invalid role");

            if (!await _roleManager.RoleExistsAsync(roleName))
                throw new BusinessException("Invalid role");

            var user = new ApplicationUser
            {
                UserName = tempUser.Name,
                Email = tempUser.Email,
                Address = tempUser.Address,
                PhoneNumber = tempUser.PhoneNumber,
                ImageUrl = tempUser.ImageUrl,
            };

            var result = await _userManager.CreateAsync(user, tempUser.Password!);
            if (!result.Succeeded)
                throw new BusinessException(string.Join(" | ", result.Errors.Select(e => e.Description)));

            await _userManager.AddToRoleAsync(user, roleName);

            var jwtToken = await GenerateToken(user);
            var refreshToken = GenerateRefreshToken();

            user.RefreshTokens ??= new();
            user.RefreshTokens.Add(refreshToken);

            await _userManager.UpdateAsync(user);

            await _unitOfWork.TempUsers.DeleteAsync(x => x.Email == tempUser.Email);
            await _unitOfWork.CompleteAsync();

            var authResult = new AuthResult
            {
                IsAuthenticated = true,
                Roles = new() { roleName },
                UserName = user.UserName,
                Email = user.Email,
                UserId = user.Id,
                PhoneNumber = user.PhoneNumber,
                Address = user.Address,
                AccessToken = new JwtSecurityTokenHandler().WriteToken(jwtToken),
                RefreshToken = refreshToken.Token,
                RefreshTokenExpiration = refreshToken.ExpiresOn,
                ExpiresIn = jwtToken.ValidTo.ToLocalTime()
            };
            return new VerifyOtpResult<AuthResult>{ Data =  authResult };
        }

        public async Task<AuthResult> Login(LoginDto loginDTO)
        {
            try
            {
                // get user and verify email
                var getUser = await _userManager.FindByEmailAsync(loginDTO.Email!);
                if (getUser is null)
                    throw new BusinessException("Invalid Email or Password");

                // password verify
                var verifyPassword = await _userManager.CheckPasswordAsync(getUser, loginDTO.Password!);
                if (!verifyPassword)
                    throw new BusinessException("Invalid Email or Password");

                // Prepare response
                var authResponse = new AuthResult();
                var token = await GenerateToken(getUser);
                var roles = await _userManager.GetRolesAsync(getUser);
                // Token Info
                authResponse.IsAuthenticated = true;
                authResponse.AccessToken = new JwtSecurityTokenHandler().WriteToken(token);
                authResponse.ExpiresIn = token.ValidTo.ToLocalTime();
                // User Info
                authResponse.UserName = getUser.UserName;
                authResponse.Email = getUser.Email;
                authResponse.UserId = getUser.Id;
                authResponse.PhoneNumber = getUser.PhoneNumber;
                authResponse.Address = getUser.Address;
                authResponse.Roles = roles.ToList();


                if (getUser.RefreshTokens!.Any(x => x.IsActive))
                {
                    var activeRefreshToken = getUser.RefreshTokens!.FirstOrDefault(x => x.IsActive);
                    authResponse.RefreshToken = activeRefreshToken!.Token;
                    authResponse.RefreshTokenExpiration = activeRefreshToken!.ExpiresOn;
                }
                else
                {
                    var refreshToken = GenerateRefreshToken();
                    authResponse.RefreshToken = refreshToken.Token;
                    authResponse.RefreshTokenExpiration = refreshToken.ExpiresOn;

                    getUser.RefreshTokens!.Add(refreshToken);
                    await _userManager.UpdateAsync(getUser);
                }


                return authResponse;
            }
            catch(BusinessException)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.Error(ex.Message, ex);
                throw;
            }
        }

        public async Task<OtpResult> ResendOtpAsync(ResendOtpDto resendOtpDto)
        {
            try
            {
                var user = await _userManager.FindByEmailAsync(resendOtpDto.Email!);
                
                if (resendOtpDto.Type == OtpTypes.EmailVerification)
                {
                    if (user != null)
                        throw new BusinessException("this email already have account");

                    var tempUser = await _unitOfWork.TempUsers.FindAsync(x => x.Email == resendOtpDto.Email);
                    if (tempUser == null)
                        throw new BusinessException("Data not found, register");

                   if (resendOtpDto.Email != tempUser.Email)
                        throw new BusinessException("Incorrect match email");

                    return await _otpService.UpdateOtpAsync(new UpdateOtpDto { Email = resendOtpDto.Email, Type = OtpTypes.EmailVerification });
                }
                else
                {
                    if (user == null) 
                        throw new BusinessException("User no have an account");

                    if (resendOtpDto.Email == null)
                        throw new BusinessException("Required email");

                    if (string.IsNullOrEmpty(resendOtpDto.Type.ToString()))
                        throw new BusinessException("Type Required");

                    return await _otpService.UpdateOtpAsync(new UpdateOtpDto { Email = resendOtpDto.Email, Type = OtpTypes.ResetPassword });
                }
            }
            catch (BusinessException)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.Error(ex.Message, ex);
                throw;
            }
        }

        public async Task<OtpResult> ForgetPassword(string email)
        {
            if (email is null)
                throw new BusinessException("Email required!");

            var user = await _userManager.FindByEmailAsync(email);
            if (user == null)
                throw new BusinessException("User not found");

            return await _otpService.GenerateAndSendOtpAsync(new AddOtpDto { Email = email, Type = OtpTypes.ResetPassword });
        }

        public async Task<bool> ResetPasswordAsync(ResetPasswordDto resetPasswordDto)
        {
            try
            {
                var user = await _userManager.FindByEmailAsync(resetPasswordDto.Email!);
                if (user is null)
                    throw new BusinessException("Invalid user");

                var token = await _userManager.GeneratePasswordResetTokenAsync(user);

                var result = await _userManager.ResetPasswordAsync(user, token, resetPasswordDto.NewPassword!);
                if (!result.Succeeded)
                {
                    var errors = string.Join(" | ", result.Errors.Select(e => e.Description));
                    throw new BusinessException(errors);
                }

                return true;
            }
            catch (BusinessException)
            {
                throw;
            }
            catch (Exception ex)
            {
                _logger.Error(ex.Message, ex);
                //return false;
                throw;
            }
        }

        public async Task<AuthResult> RefreshTokenAsync(string token)
        {
            var authResponse = new AuthResult();

            var user = await _userManager.Users.SingleOrDefaultAsync(x => x.RefreshTokens!.Any(x => x.Token == token));
            if (user is null)
                throw new BusinessException("Invalid token");

            var refreshToken = user.RefreshTokens!.Single(x => x.Token == token);
            if (!refreshToken.IsActive)
                throw new BusinessException("InActive token");

            refreshToken.IsRevoked = true;
            refreshToken.RevokedOn = DateTime.UtcNow;

            var roles = await _userManager.GetRolesAsync(user);

            // Prepare refresh token(generate and added to DB)
            var newRefreshToken = GenerateRefreshToken();
            user.RefreshTokens!.Add(newRefreshToken);
            await _userManager.UpdateAsync(user);
            authResponse.RefreshToken = refreshToken.Token;
            authResponse.RefreshTokenExpiration = newRefreshToken.ExpiresOn;
            authResponse.IsAuthenticated = true;

            // Prepare JWT token(generate)
            var accessToken = await GenerateToken(user);
            authResponse.AccessToken = new JwtSecurityTokenHandler().WriteToken(accessToken);
            authResponse.ExpiresIn = accessToken.ValidTo.ToLocalTime();

            // Prepare user information
            authResponse.Address = user.Address;
            authResponse.Email = user.Email;
            authResponse.UserName = user.UserName;
            authResponse.PhoneNumber = user.PhoneNumber;
            authResponse.UserId = user.Id;
            authResponse.Roles = roles.ToList();

            return authResponse;
        }

        public async Task RevokeTokenAsync(string token)
        {
            var user = await _userManager.Users.SingleOrDefaultAsync(x => x.RefreshTokens!.Any(x => x.Token == token));
            if (user == null)
                throw new BusinessException("Invalid token");

            var refreshToken = user.RefreshTokens!.Single(x => x.Token == token);
            if (!refreshToken.IsActive)
                throw new BusinessException("InActive token");

            // became revoked after these lines
            refreshToken.IsRevoked = true;
            refreshToken.RevokedOn = DateTime.UtcNow.ToLocalTime();

            await _userManager.UpdateAsync(user);
        }

        // Generate Token 
        private async Task<JwtSecurityToken> GenerateToken(ApplicationUser applicationUser)
        {
            var claims = new List<Claim>()
            {
                new(ClaimTypes.NameIdentifier, applicationUser.Id),
                new(ClaimTypes.Name, applicationUser.UserName!),
                new(ClaimTypes.Email, applicationUser.Email!),
            };
            // get role
            var userRoles = await _userManager.GetRolesAsync(applicationUser);
            foreach (var role in userRoles)
            {
                claims.Add(new(ClaimTypes.Role, role));
            }

            var key = Encoding.UTF8.GetBytes(configuration["JWTAuth:Key"]!);

            var securitKey = new SymmetricSecurityKey(key);

            var credentials = new SigningCredentials(securitKey, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken
                (
                issuer: configuration["JWTAuth:Issuer"],
                audience: configuration["JWTAuth:Audience"],
                expires: DateTime.UtcNow.AddDays(1),
                claims: claims,
                signingCredentials: credentials
                );

            return token;
        }

        //Generate Refresh Token
        private RefreshToken GenerateRefreshToken()
        {
            var randomBytes = new byte[64];

            using (RandomNumberGenerator generator = RandomNumberGenerator.Create())
            {
                generator.GetBytes(randomBytes);
            }
            string token = Convert.ToBase64String(randomBytes);

            return new RefreshToken
            {
                Token = token,
                ExpiresOn = DateTime.UtcNow.AddDays(3),
                CreatedOn = DateTime.UtcNow,
            };
        }
    }
}
