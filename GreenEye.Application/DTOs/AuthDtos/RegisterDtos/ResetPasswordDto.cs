using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.AuthDtos.RegisterDtos
{
    public class ResetPasswordDto
    {
        [Required]
        [EmailAddress]
        public string? Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string? NewPassword { get; set; }
    }
}
