using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.CropRecommendation;
using Microsoft.Extensions.Configuration;
using System.Net.Http.Json;
using System.Text;
using System.Text.Json;

namespace GreenEye.Application.Services.CropRecommendation
{
    public class CropRecommendationModelService : ICropRecommendationModelService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _config;

        public CropRecommendationModelService(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            _config = config;
        }

        public async Task<List<string>> GetRecommendationsAsync(object inputData)
        {
            var jsonContent = JsonSerializer.Serialize(inputData, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            var content = new StringContent(
                jsonContent,
                Encoding.UTF8,
                "application/json");

            var apiUrl = _config["ExternalApis:CropRecommendationApi"];

            var response = await _httpClient.PostAsJsonAsync(apiUrl, inputData);

            if (!response.IsSuccessStatusCode)
            {
                throw new BusinessException("Crop Recommendation model is currently unavailable. Please try again later.", 503);
            }

            var responseString = await response.Content.ReadAsStringAsync();
            var recommendationResult = JsonSerializer.Deserialize<Dictionary<string, string>>(responseString, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            if (recommendationResult == null)
            {
                throw new BusinessException("Failed to process crop recommendation results", 500);
            }

            return recommendationResult.Values.ToList();
        }
    }
}
