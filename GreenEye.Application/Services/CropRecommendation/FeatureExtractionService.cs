using GreenEye.Application.DTOs.CropRecommendation;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.CropRecommendation;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;

namespace GreenEye.Application.Services.CropRecommendation
{
    public class FeatureExtractionService : IFeatureExtractionService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _config;

        public FeatureExtractionService(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            _config = config;
        }

        public async Task<FeatureExtractionResponseDto> ExtractFeaturesAsync(double latitude, double longitude)
        {
            var baseUrl = _config["ExternalApis:FeatureExtractionApi"];

            var requestBody = new
            {
                latitude = latitude,
                longitude = longitude
            };

            var content = new StringContent(
                JsonSerializer.Serialize(requestBody),
                Encoding.UTF8,
                "application/json");

            var response = await _httpClient.PostAsync(baseUrl, content);

            if (!response.IsSuccessStatusCode)
            {
                throw new BusinessException("Failed to extract features from external service", 503);
            }

            var responseString = await response.Content.ReadAsStringAsync();
            
            var result = JsonSerializer.Deserialize<FeatureExtractionResponseDto>(responseString, new JsonSerializerOptions 
            { 
                PropertyNameCaseInsensitive = true 
            });

            if (result == null)
            {
                throw new BusinessException("Failed to process feature extraction results", 500);
            }

            return result;
        }
    }
}
