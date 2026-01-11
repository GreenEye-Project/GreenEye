using GreenEye.Domain.Entities;
using Microsoft.AspNetCore.Identity;

namespace GreenEye.Infrastructure.Entities.IdentityModel
{
    public class ApplicationUser : IdentityUser
    {
        public string? ImageUrl { get; set; }
        public string? Address { get; set; }
        public bool IsApproved { get; set; }

        public List<RefreshToken>? RefreshTokens { get; set; } = new();
    }
}
