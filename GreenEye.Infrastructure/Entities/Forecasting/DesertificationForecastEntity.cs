using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Infrastructure.Entities.IdentityModel;

namespace GreenEye.Infrastructure.Entities.Forecasting
{
    public class DesertificationForecastEntity: DesertificationForecast
    {
        public ApplicationUser? User { get; set; }
    }
}
