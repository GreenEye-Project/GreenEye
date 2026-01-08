using GreenEye.Domain.Entities.Forecasting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Domain.IRepositories.Forecasting
{
    public interface IDesertificationForecastRepository : IGenericRepository<DesertificationForecast>
    {
        Task<IEnumerable<DesertificationForecast>> GetForecastsByLocationAsync(double latitude,double longitude,string userId);

        Task<IEnumerable<DesertificationForecast>> GetUserForecastsAsync(string userId);

        Task SoftDeleteForecastsAsync(double latitude,double longitude,string userId);

    }
}
