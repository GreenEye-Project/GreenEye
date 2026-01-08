using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Forecasting
{
    // Response from Forecasting API (API 2)
    public class ForecastingResponse
    {
        [JsonPropertyName("success")]
        public bool Success { get; set; }

        [JsonPropertyName("forecast")]
        public List<ForecastItemDto>? Forecast { get; set; }
    }
}
