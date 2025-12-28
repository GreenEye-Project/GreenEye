using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.OtpDtos
{
    public class OtpBase
    {
        [Required]
        [DataType(DataType.EmailAddress)]
        public string? Email { get; set; }
    }
}
