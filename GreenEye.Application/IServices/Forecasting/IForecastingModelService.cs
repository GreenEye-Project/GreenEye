using GreenEye.Application.DTOs.Forecasting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Application.IServices.Forecasting
{
    public interface IForecastingModelService
    {
        Task<ForecastingResponse> GetForecastAsync(ForecastingInputRequest input);

    }
}
