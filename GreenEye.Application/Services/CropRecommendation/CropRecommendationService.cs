using GreenEye.Application.DTOs.CropRecommendation;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.CropRecommendation;
using GreenEye.Domain.Entities.CropRecommendation;
using GreenEye.Domain.IRepositories;
using GreenEye.Domain.IRepositories.CropRecommendation;
using AutoMapper;

namespace GreenEye.Application.Services.CropRecommendation
{
    public class CropRecommendationService : ICropRecommendationService
    {
        private readonly IFeatureExtractionService _featureExtractionService;
        private readonly ICropRecommendationModelService _cropRecommendationModelService;
        private readonly ICropRecommendationRepository _repository;
        private readonly IUnitOfWrok _unitOfWork;
        private readonly IMapper _mapper;

        public CropRecommendationService(
            IFeatureExtractionService featureExtractionService,
            ICropRecommendationModelService cropRecommendationModelService,
            ICropRecommendationRepository repository,
            IUnitOfWrok unitOfWork,
            IMapper mapper)
        {
            _featureExtractionService = featureExtractionService;
            _cropRecommendationModelService = cropRecommendationModelService;
            _repository = repository;
            _unitOfWork = unitOfWork;
            _mapper = mapper;
        }

        public async Task<CropRecommendationResponseDto> GetRecommendationAsync(double latitude, double longitude, string userId)
        {
            // 1. Get Soil and Weather Features
            var featuresResponse = await _featureExtractionService.ExtractFeaturesAsync(latitude, longitude);



            if (!featuresResponse.Success || featuresResponse.Features == null)
            {
                throw new BusinessException("Could not extract soil and weather features for this location.");
            }

            // 2. Map to Crop Recommendation API Input
            var features = featuresResponse.Features;
            var recommendationInput = new
            {
                metadata = new
                {
                    location_name = featuresResponse.Metadata?.LocationName ?? $"{latitude},{longitude}"
                },
                features = new
                {
                    year = features.Year,
                    month = features.Month,
                    sand = features.Sand,
                    silt = features.Silt,
                    clay = features.Clay,
                    soc = features.Soc,
                    ph = features.Ph,
                    bdod = features.Bdod,
                    cec = features.Cec,
                    ndvi = features.Ndvi,
                    t2m_c = features.T2mC,
                    td2m_c = features.Td2mC,
                    rh_pct = features.RhPct,
                    tp_m = features.TpM,
                    ssrd_jm2 = features.SsrdJm2,
                    lc_type1 = features.LcType1,
                    nitrogen = features.Nitrogen,
                    phosphorus = features.Phosphorus,
                    potassium = features.Potassium,
                    latitude = features.Latitude,
                    longitude = features.Longitude
                }
            };

            // 3. Call Crop Recommendation Model
            var recommendedCrops = await _cropRecommendationModelService.GetRecommendationsAsync(features);

            // 4. Save to History
            var entity = new CropRecommendationResult
            {
                UserId = userId,
                Latitude = latitude,
                Longitude = longitude,
                LocationName = featuresResponse.Metadata?.LocationName ?? $"{latitude},{longitude}",
                RecommendedCrops = recommendedCrops,
                CreatedAt = DateTime.UtcNow,
                IsDeleted = false
            };

            await _repository.AddAsync(entity);
            await _unitOfWork.CompleteAsync();

            return new CropRecommendationResponseDto
            {
                RecommendedCrops = recommendedCrops,
                GeneratedAt = entity.CreatedAt
            };
        }

        public async Task<List<CropRecommendationHistoryDto>> GetUserHistoryAsync(string userId)
        {
            var history = await _repository.GetUserHistoryAsync(userId);
            return _mapper.Map<List<CropRecommendationHistoryDto>>(history);
        }
    }
}
