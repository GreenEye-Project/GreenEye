using GreenEye.Domain.Entities.CropRecommendation;
using GreenEye.Domain.Interfaces.IRepositories.Generics;

namespace GreenEye.Domain.IRepositories.CropRecommendation
{
    public interface ICropRecommendationRepository : IGenericRepository<CropRecommendationResult>
    {
        Task<List<CropRecommendationResult>> GetUserHistoryAsync(string userId);
    }
}
