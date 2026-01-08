using GreenEye.Domain.Enums;
using Microsoft.AspNetCore.Http;
using System.ComponentModel.DataAnnotations;

namespace GreenEye.Application.DTOs.AuthDtos.RegisterDtos
{
    public class RegisterDto
    {
        [Required]
        public IFormFile? ImageFile { get; set; }

        [Required]
        [MaxLength(255)]
        [MinLength(3)]
        public string? Name { get; set; }

        [Required]
        [EmailAddress]
        public string? Email { get; set; }

        [Required]
        [MaxLength(255)]
        [MinLength(3)]
        public string? Address { get; set; }

        [Required]
        [RegularExpression(@"^\d{11}$", ErrorMessage = "Phone number must be 11 number")]
        public string? PhoneNumber { get; set; }

        [Required]
        [DataType(DataType.Password)]
        public string? Password { get; set; }

        [Required]
        [Compare("Password")]
        [DataType(DataType.Password)]
        public string? ConfirmPassword { get; set; }

        [Required]
        public Roles Role { get; set; }
    }
}
