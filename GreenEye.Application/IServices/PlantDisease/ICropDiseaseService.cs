using GreenEye.Application.DTOs.PlantDisease;
using GreenEye.Application.Responses;
using Microsoft.AspNetCore.Http;

namespace GreenEye.Application.IServices.PlantDisease
{
    public interface ICropDiseaseService
    {
        Task<CropDiseaseModelResponseDto> DetectDiseaseAsync(IFormFile image, string userId);
        Task<List<CropDiseaseHistoryDto>> GetUserHistoryAsync(string userId);
        Task DeleteHistoryAsync(int historyId, string userId);

    }
}
