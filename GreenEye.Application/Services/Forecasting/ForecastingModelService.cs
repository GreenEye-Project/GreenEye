using GreenEye.Application.DTOs.Forecasting;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.Forecasting;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
using System.Text;
using System.Text.Json;

namespace GreenEye.Application.Services.Forecasting
{
    public class ForecastingModelService : IForecastingModelService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _config;

        public ForecastingModelService(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            _config = config;
        }

        public async Task<ForecastingResponse> GetForecastAsync(ForecastingInputRequest input)
        {
            // Serialize input to JSON with camelCase
            var jsonContent = JsonSerializer.Serialize(input, new JsonSerializerOptions
            {
                PropertyNamingPolicy = JsonNamingPolicy.CamelCase
            });

            var content = new StringContent(jsonContent, Encoding.UTF8, "application/json");

           
            var apiUrl = _config["ExternalApis:ForecastingModelUrl"];

            // Call external AI model
            var response = await _httpClient.PostAsync(apiUrl, content);

            if (!response.IsSuccessStatusCode)
            {
                throw new BusinessException("Forecasting model is currently unavailable. Please try again later", 503 );
            }

            // Deserialize response
            var responseContent = await response.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<ForecastingResponse>(responseContent, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            if (result == null)
            {
                throw new BusinessException("Failed to process forecast results", 500);
            }

            return result;
        }
    }
}
