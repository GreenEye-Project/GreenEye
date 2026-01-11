using GreenEye.Domain.Entities.PlantDisease;
using GreenEye.Domain.Interfaces.IRepositories.Generics;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GreenEye.Domain.Interfaces.IRepositories.PlantDisease
{
    public interface ICropDiseaseRepository : IGenericRepository<CropDisease>
    {
        Task<IEnumerable<CropDisease>> GetUserHistoryAsync(string userId);
        Task<CropDisease?> GetUserHistoryItemAsync(int historyId, string userId);
    }
}
