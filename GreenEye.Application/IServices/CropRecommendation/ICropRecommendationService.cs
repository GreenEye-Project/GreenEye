using GreenEye.Application.DTOs.CropRecommendation;

namespace GreenEye.Application.IServices.CropRecommendation
{
    public interface ICropRecommendationService
    {
        Task<CropRecommendationResponseDto> GetRecommendationAsync(double latitude, double longitude, string userId);
        Task<List<CropRecommendationHistoryDto>> GetUserHistoryAsync(string userId);
    }
}
