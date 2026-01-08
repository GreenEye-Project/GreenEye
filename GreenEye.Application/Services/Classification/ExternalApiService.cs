using GreenEye.Application.DTOs.ExternalApi;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.Classification;
using Microsoft.Extensions.Configuration;
using System.Net.Http.Json;
using System.Text.Json;

namespace GreenEye.Application.Services.Classification
{
    public class ExternalApiService : IExternalApiService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _configuration;

        public ExternalApiService(HttpClient httpClient, IConfiguration configuration)
        {
            _httpClient = httpClient;
            _configuration = configuration;            
        }
        public async Task<ExternalApiReponse?> GetExternalData(double longitude, double latitude)
        {
            var response = await _httpClient.PostAsJsonAsync(_configuration["ExternalApis:RealTimeDataApi"],new { longitude , latitude });

            if (!response.IsSuccessStatusCode)
                throw new BusinessException("Failed to load location data!");

            var content = await response.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ExternalApiReponse>(
                content,
                new JsonSerializerOptions
                {
                    PropertyNameCaseInsensitive = true
                });

            return result;
        }
    }
}
