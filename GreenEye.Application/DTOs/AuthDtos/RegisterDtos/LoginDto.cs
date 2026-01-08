using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.AuthDtos.RegisterDtos
{
    public class LoginDto
    {
        [Required]
        [EmailAddress]
        public string? Email { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string? Password { get; set; }
    }
}
