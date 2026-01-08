using GreenEye.Domain.Entities;
using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Domain.Entities.PlantDisease;
using GreenEye.Infrastructure.Entities.IdentityModel;
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore;

namespace GreenEye.Infrastructure.Data
{
    public class AppDbContext : IdentityDbContext<ApplicationUser>
    {
        public AppDbContext(DbContextOptions<AppDbContext> options) : base(options)
        {
            
        }

        public DbSet<OTP> OTPs {  get; set; }
        public DbSet<CropDisease> CropDiseases { get; set; }
        public DbSet<TempUser> TempUsers { get; set; }
        public DbSet<DesertificationForecast> DesertificationForecasts { get; set; }

    }
}
