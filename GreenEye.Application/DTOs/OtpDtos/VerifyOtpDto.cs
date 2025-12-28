using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.OtpDtos
{
    public class VerifyOtpDto : OtpBase
    {
        [Required]
        public string? Code { get; set; }
    }
}
