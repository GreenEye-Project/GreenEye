using GreenEye.Domain.Entities;
using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Domain.Entities.PlantDisease;
using GreenEye.Domain.Entities.CropRecommendation;
using GreenEye.Infrastructure.IdentityModel;
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
        public DbSet<DesertificationForecast> DesertificationForecasts { get; set; }
        public DbSet<CropRecommendationResult> CropRecommendationResults { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            base.OnModelCreating(builder);

            builder.Entity<CropRecommendationResult>()
                .Property(e => e.RecommendedCrops)
                .HasConversion(
                    v => string.Join(',', v),
                    v => v.Split(',', StringSplitOptions.RemoveEmptyEntries).ToList())
                .Metadata.SetValueComparer(new Microsoft.EntityFrameworkCore.ChangeTracking.ValueComparer<List<string>>(
                    (c1, c2) => c1.SequenceEqual(c2),
                    c => c.Aggregate(0, (a, v) => HashCode.Combine(a, v.GetHashCode())),
                    c => c.ToList()));
        }

    }
}
