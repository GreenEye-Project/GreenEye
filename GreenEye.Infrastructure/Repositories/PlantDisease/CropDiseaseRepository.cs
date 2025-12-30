using GreenEye.Domain.Entities.PlantDisease;
using GreenEye.Domain.IRepositories.PlantDisease;
using GreenEye.Infrastructure.Data;
using Microsoft.EntityFrameworkCore;

namespace GreenEye.Infrastructure.Repositories.PlantDisease
{
    internal class CropDiseaseRepository : GenericRepository<CropDisease>, ICropDiseaseRepository
    {
        private readonly AppDbContext _context;

        public CropDiseaseRepository(AppDbContext context) : base(context)
        {
            _context = context;
        }

        public async Task<IEnumerable<CropDisease>> GetUserHistoryAsync(string userId)
        {
            return await _context.CropDiseases
                .Where(h => h.UserId == userId && !h.IsDeleted)
                .OrderByDescending(h => h.SentAt)
                .AsNoTracking()
                .ToListAsync();
        }

        public async Task<CropDisease?> GetUserHistoryItemAsync(int historyId, string userId)
        {
            return await _context.CropDiseases
                .FirstOrDefaultAsync(h => h.Id == historyId && h.UserId == userId && !h.IsDeleted);
        }
    }
}
