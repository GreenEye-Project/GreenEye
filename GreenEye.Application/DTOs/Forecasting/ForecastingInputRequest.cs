using System.Text.Json.Serialization;

namespace GreenEye.Application.DTOs.Forecasting
{
    // Input to Forecasting API (API 2)
    public class ForecastingInputRequest
    {
        [JsonPropertyName("data")]
        public List<ForecastingInputItem>? Data { get; set; }
    }
}
