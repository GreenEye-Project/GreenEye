using GreenEye.Domain.Entities.CropRecommendation;
using GreenEye.Domain.IRepositories.CropRecommendation;
using GreenEye.Infrastructure.Data;
using GreenEye.Infrastructure.Implementations.Repositories.Generics;
using GreenEye.Infrastructure.Repositories;
using Microsoft.EntityFrameworkCore;

namespace GreenEye.Infrastructure.Repositories.CropRecommendation
{
    public class CropRecommendationRepository : GenericRepository<CropRecommendationResult>, ICropRecommendationRepository
    {
        private readonly AppDbContext _context;

        public CropRecommendationRepository(AppDbContext context) : base(context)
        {
            _context = context;
        }

        public async Task<List<CropRecommendationResult>> GetUserHistoryAsync(string userId)
        {
            return await _context.Set<CropRecommendationResult>()
                .Where(x => x.UserId == userId && !x.IsDeleted)
                .OrderByDescending(x => x.CreatedAt)
                .ToListAsync();
        }
    }
}
