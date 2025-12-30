using GreenEye.Domain.Entities.PlantDisease;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Domain.IRepositories.PlantDisease
{
    public interface ICropDiseaseRepository : IGenericRepository<CropDisease>
    {
        Task<IEnumerable<CropDisease>> GetUserHistoryAsync(string userId);
        Task<CropDisease?> GetUserHistoryItemAsync(int historyId, string userId);
    }
}
