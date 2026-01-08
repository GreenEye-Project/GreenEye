using GreenEye.Application.DTOs.Forecasting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Application.IServices.Forecasting
{
    public interface IHistoryDataService
    {
        Task<HistoryDataResponse> Get12MonthsHistoryAsync(double latitude, double longitude);
    }
}
