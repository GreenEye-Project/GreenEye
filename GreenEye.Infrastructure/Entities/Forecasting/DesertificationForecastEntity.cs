using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Infrastructure.IdentityModel;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Infrastructure.Entities.Forecasting
{
    internal class DesertificationForecastEntity: DesertificationForecast
    {
        public ApplicationUser? User { get; set; }
    }
}
