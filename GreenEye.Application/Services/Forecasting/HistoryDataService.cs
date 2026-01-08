using GreenEye.Application.DTOs.Forecasting;
using GreenEye.Application.Exceptions;
using GreenEye.Application.IServices.Forecasting;
using Microsoft.Extensions.Configuration;
using System.Net.Http;
using System.Text.Json;
using System.Threading.Tasks;

namespace GreenEye.Application.Services.Forecasting
{
    public class HistoryDataService : IHistoryDataService
    {
        private readonly HttpClient _httpClient;
        private readonly IConfiguration _config;

        public HistoryDataService(HttpClient httpClient, IConfiguration config)
        {
            _httpClient = httpClient;
            _config = config;
        }


        public async Task<HistoryDataResponse> Get12MonthsHistoryAsync(double latitude, double longitude)
        {
           
            var baseUrl = _config["ExternalApis:HistoryDataApi"];

            // تجهيز body للـ POST Method 
            var requestBody = new
            {
                latitude = latitude,
                longitude = longitude
            };

            var content = new StringContent(
                JsonSerializer.Serialize(requestBody),
                System.Text.Encoding.UTF8,
                "application/json"
            );

            // POST request
            var response = await _httpClient.PostAsync(baseUrl, content);

            if (!response.IsSuccessStatusCode)
            {
                throw new BusinessException(
                    "Unable to retrieve historical data. Please check the location coordinates", 503
                );
            }

            var responseContent = await response.Content.ReadAsStringAsync();

            var result = JsonSerializer.Deserialize<HistoryDataResponse>(responseContent, new JsonSerializerOptions
            {
                PropertyNameCaseInsensitive = true
            });

            if (result == null)
            {
                throw new BusinessException("Failed to process historical data", 500);
            }

            return result;
        }

        
    }
}
