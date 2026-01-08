using GreenEye.Domain.Entities.CropRecommendation;

namespace GreenEye.Domain.IRepositories.CropRecommendation
{
    public interface ICropRecommendationRepository : IGenericRepository<CropRecommendationResult>
    {
        Task<List<CropRecommendationResult>> GetUserHistoryAsync(string userId);
    }
}
