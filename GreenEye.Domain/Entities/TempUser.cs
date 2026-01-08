using GreenEye.Domain.Enums;
using System.ComponentModel.DataAnnotations;

namespace GreenEye.Domain.Entities
{
    public class TempUser
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string? ImageUrl { get; set; }

        [Required]
        [MaxLength(255)]
        [MinLength(3)]
        public string? Name { get; set; }

        [Required]
        [DataType(DataType.EmailAddress)]
        public string? Email { get; set; }

        [Required]
        [MaxLength(255)]
        public string? Address { get; set; }

        [Required]
        [RegularExpression(@"^\d{11}$", ErrorMessage = "Phone number must be 11 number")]
        public string? PhoneNumber { get; set; }

        [Required]
        public string? Password { get; set; }

        public bool IsApproved { get; set; }
        public Roles Role { get; set; }

    }
}
