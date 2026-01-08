using AutoMapper;
using GreenEye.Application.DTOs.Forecasting;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.Forecasting;
using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Domain.IRepositories;
using GreenEye.Domain.IRepositories.Forecasting;
using System.Text.Json;

namespace GreenEye.Application.Services.Forecasting
{
    public class ForecastingService : IForecastingService
    {
        private readonly IHistoryDataService _historyDataService;
        private readonly IForecastingModelService _forecastingModelService;
        private readonly IDesertificationForecastRepository _forecastRepository;
        private readonly IUnitOfWrok _unitOfWork;
        private readonly IMapper _mapper;

        public ForecastingService(
            IHistoryDataService historyDataService,
            IForecastingModelService forecastingModelService,
            IDesertificationForecastRepository forecastRepository,
            IUnitOfWrok unitOfWork,
            IMapper mapper)
        {
            _historyDataService = historyDataService;
            _forecastingModelService = forecastingModelService;
            _forecastRepository = forecastRepository;
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<ForecastResponseDto> GetDesertificationForecastAsync(double latitude,double longitude,string userId)
        {

            var historyData = await _historyDataService.Get12MonthsHistoryAsync(latitude, longitude);
          
            if (!historyData.Success || historyData.Features == null || historyData.Features.Count == 0)
            {
                throw new BusinessException("Unable to retrieve historical data for the specified location",404);
            }

            var forecastingInput = new ForecastingInputRequest
            {
                Data = historyData.Features.Select(f => new ForecastingInputItem
                {
                    Metadata = new ForecastingMetadataDto
                    {
                        LocationName = historyData.LocationName ?? $"{latitude},{longitude}"
                    },
                    Features = new ForecastingFeaturesDto
                    {
                        Year = f.Year,
                        Month = f.Month,
                        Ndvi = f.Ndvi ,
                        T2mC = f.T2mC,
                        Td2mC = f.Td2mC,
                        RhPct = f.RhPct,
                        TpM = f.TpM ,
                        SsrdJm2 = f.SsrdJm2,
                        Sand = f.Sand ,
                        Silt = f.Silt,
                        Clay = f.Clay,
                        Soc = f.Soc,
                        Ph = f.Ph,
                        Bdod = f.Bdod,
                        Cec = f.Cec,
                        Nitrogen = f.Nitrogen,
                        Phosphorus = f.Phosphorus,
                        Potassium = f.Potassium,
                        LcType1 = f.LcType1
                    }
                }).ToList()
            };

            var forecastResult = await _forecastingModelService.GetForecastAsync(forecastingInput);

            if (!forecastResult.Success || forecastResult.Forecast == null)
            {
                throw new BusinessException("Unable to generate forecast. Please try again later", 503);
            }

            var lastYear = forecastResult.Forecast.Max(f => f.Year);

            var lastYearForecasts =
               forecastResult.Forecast
                    .Where(f => f.Year == lastYear)
                    .ToList();

            await _forecastRepository.SoftDeleteForecastsAsync(latitude, longitude, userId);

            
                var forecastEntities = _mapper.Map<List<DesertificationForecast>>(lastYearForecasts);

                foreach (var entity in forecastEntities)
                {
                    entity.Latitude = latitude;
                    entity.Longitude = longitude;
                    entity.LocationName = historyData.LocationName;
                    entity.UserId = userId;
                    entity.CreatedAt = DateTime.UtcNow;
                    entity.IsDeleted = false;
                }


                await _forecastRepository.AddRangeAsync(forecastEntities);
                await _unitOfWork.CompleteAsync();
           
            return new ForecastResponseDto
            {
                Latitude = latitude,
                Longitude = longitude,
                LocationName = historyData.LocationName,
                Forecasts = lastYearForecasts,
                GeneratedAt = DateTime.UtcNow
            };
        }

        public async Task<List<ForecastHistoryDto>> GetUserForecastHistoryAsync(string userId)
        {
            var forecasts = await _forecastRepository.GetUserForecastsAsync(userId);

            return forecasts
                .GroupBy(f => new
                {
                    f.Latitude,
                    f.Longitude,
                    f.LocationName
                })
                .Select(g => new ForecastHistoryDto
                {
                    Latitude = g.Key.Latitude,
                    Longitude = g.Key.Longitude,
                    LocationName = g.Key.LocationName,
                    LastUpdated = g.Max(f => f.CreatedAt),
                    TotalForecasts = g.Count(),
                    LatestRiskLevel =
                        g.OrderByDescending(f => f.CreatedAt)
                         .First()
                         .RiskLevel
                })
                .OrderByDescending(f => f.LastUpdated)
                .ToList();
        }
    }
}
