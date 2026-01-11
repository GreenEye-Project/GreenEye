using GreenEye.Domain.Enums;
using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.AuthDtos.OtpDtos
{
    public class OtpBase
    {
        [Required]
        [DataType(DataType.EmailAddress)]
        public string? Email { get; set; }

        public OtpTypes? Type { get; set; }
    }
}
