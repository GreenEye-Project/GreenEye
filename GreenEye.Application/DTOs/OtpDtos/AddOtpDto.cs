using GreenEye.Domain.Enums;
using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.OtpDtos
{
    public class AddOtpDto : OtpBase
    {
        [Required]
        public OtpTypes Type { get; set; }
    }
}
