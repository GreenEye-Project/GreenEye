using GreenEye.Application.DTOs.CropRecommendation;

namespace GreenEye.Application.IServices.CropRecommendation
{
    public interface IFeatureExtractionService
    {
        Task<FeatureExtractionResponseDto> ExtractFeaturesAsync(double latitude, double longitude);
    }
}
