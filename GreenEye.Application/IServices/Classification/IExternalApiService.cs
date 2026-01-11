using GreenEye.Application.DTOs.ExternalApi;

namespace GreenEye.Application.IServices.Classification
{
    public interface IExternalApiService
    {
        Task<ExternalApiReponse?> GetExternalData(double longitude, double latitude);
    }
}
