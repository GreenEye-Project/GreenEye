using AutoMapper;
using GreenEye.Application.DTOs.AuthDtos.OtpDtos;
using GreenEye.Application.DTOs.CropGrowthSimulation;
using GreenEye.Application.DTOs.ExternalApi;
using GreenEye.Application.DTOs.ExternalData;
using GreenEye.Application.DTOs.CropRecommendation;
using GreenEye.Application.DTOs.Forecasting;
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

            
            CreateMap<FeaturesDto, SimulationFeaturesForRequest>()
                .ForMember(dest => dest.Temperature,
                opt => opt.MapFrom(src => src.t2m_c ?? 0));
        }
    }
}
