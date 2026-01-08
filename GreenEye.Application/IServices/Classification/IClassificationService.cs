using GreenEye.Application.DTOs.Classification;

namespace GreenEye.Application.IServices.Classification
{
    public interface IClassificationService
    {
        Task<ClassificationResponse?> GetClassificationAsync(double longitude, double latitude);
    }
}
