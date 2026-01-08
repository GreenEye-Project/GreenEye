using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Domain.Interfaces.IRepositories.Forecasting;
using GreenEye.Infrastructure.Data;
using GreenEye.Infrastructure.Implementations.Repositories.Generics;
using Microsoft.EntityFrameworkCore;

namespace GreenEye.Infrastructure.Implementations.Repositories.Forecasting
{
    public class DesertificationForecastRepository
        : GenericRepository<DesertificationForecast>,IDesertificationForecastRepository
    {
        private readonly AppDbContext _context;

        public DesertificationForecastRepository(AppDbContext context) : base(context)
        {
            _context = context;
        }

        public async Task<IEnumerable<DesertificationForecast>> GetForecastsByLocationAsync(double latitude,double longitude,string userId)
        {
            return await _context.DesertificationForecasts
                .Where(f =>
                    f.Latitude == latitude &&
                    f.Longitude == longitude &&
                    f.UserId == userId &&
                    !f.IsDeleted)
                .OrderBy(f => f.Year)
                .ThenBy(f => f.Month)
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<IEnumerable<DesertificationForecast>> GetUserForecastsAsync(string userId)
        {
            return await _context.DesertificationForecasts
                .Where(f => f.UserId == userId && !f.IsDeleted)
                .OrderByDescending(f => f.CreatedAt)
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task SoftDeleteForecastsAsync(double latitude,double longitude,string userId)
        {
            var forecasts = await _context.DesertificationForecasts
                .Where(f =>
                    f.Latitude == latitude &&
                    f.Longitude == longitude &&
                    f.UserId == userId &&
                    !f.IsDeleted)
                .ToListAsync();

            foreach (var forecast in forecasts)
            {
                forecast.IsDeleted = true;
            }
        }
    }
}
