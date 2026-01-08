using AutoMapper;
using GreenEye.Application.DTOs.CropRecommendation;
using GreenEye.Application.DTOs.Forecasting;
using GreenEye.Application.DTOs.OtpDtos;
using GreenEye.Application.DTOs.PlantDisease;
using GreenEye.Domain.Entities;
using GreenEye.Domain.Entities.CropRecommendation;
using GreenEye.Domain.Entities.Forecasting;
using GreenEye.Domain.Entities.PlantDisease;

namespace GreenEye.Application.Mapping
{
    public class MappingProfile : Profile
    {
        public MappingProfile()
        {

            // OTP
            CreateMap<AddOtpDto, OTP>();

            // Crop Disease
            CreateMap<CropDisease, CropDiseaseHistoryDto>();
            CreateMap<CropDisease, CropDiseaseModelResponseDto>();

            // Crop Recommendation
             CreateMap<CropRecommendationResult, CropRecommendationHistoryDto>();

            // Forecasting Features Mapping (History -> DTO)
            CreateMap<HistoryFeatureDto, ForecastingFeaturesDto>();

            // ForecastItemDto -> DesertificationForecast
            CreateMap<ForecastItemDto, DesertificationForecast>();
        }
    }
}
