namespace GreenEye.Application.IServices.CropRecommendation
{
    public interface ICropRecommendationModelService
    {
        Task<List<string>> GetRecommendationsAsync(object inputData);
    }
}
