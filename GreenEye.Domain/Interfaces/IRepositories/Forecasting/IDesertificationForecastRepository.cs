using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Domain.Interfaces.IRepositories.Generics;

namespace GreenEye.Domain.Interfaces.IRepositories.Forecasting
{
    public interface IDesertificationForecastRepository : IGenericRepository<DesertificationForecast>
    {
        Task<IEnumerable<DesertificationForecast>> GetForecastsByLocationAsync(double latitude,double longitude,string userId);

        Task<IEnumerable<DesertificationForecast>> GetUserForecastsAsync(string userId);

        Task SoftDeleteForecastsAsync(double latitude,double longitude,string userId);

    }
}
