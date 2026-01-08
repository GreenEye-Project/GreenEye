using GreenEye.Application.DTOs.Forecasting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Application.IServices.Forecasting
{
    public interface IForecastingService
    {
        Task<ForecastResponseDto> GetDesertificationForecastAsync(double latitude,double longitude,string userId);

        Task<List<ForecastHistoryDto>> GetUserForecastHistoryAsync(string userId);
    }
}
