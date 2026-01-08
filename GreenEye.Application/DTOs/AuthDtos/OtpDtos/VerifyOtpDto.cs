using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.AuthDtos.OtpDtos
{
    public class VerifyOtpDto : OtpBase
    {
        [Required]
        [RegularExpression(@"^\d{6}$", ErrorMessage = "OTP must be 6 digits")]
        public string? Code { get; set; }
    }
}
